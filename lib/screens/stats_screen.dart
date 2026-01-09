import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/master_provider.dart';
import '../providers/stats_provider.dart';
import '../models/body_part.dart';
import '../models/exercise.dart';
import '../utils/constants.dart';
import '../utils/date_helper.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String? _selectedBodyPartId;
  String? _selectedExerciseId;
  List<Map<String, dynamic>> _history = [];
  int _selectedPeriod = 30; // 0 means 'All'

  final Map<int, String> _periodLabels = {
    7: '7日',
    30: '30日',
    90: '90日',
    0: '全期間',
  };


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final masterProvider = context.read<MasterProvider>();
      if (masterProvider.bodyParts.isNotEmpty) {
        setState(() {
          _selectedBodyPartId = masterProvider.bodyParts.first.id;
        });
      }
    });
  }

  void _onBodyPartChanged(String? newValue) {
    if (newValue == _selectedBodyPartId) return;
    
    setState(() {
      _selectedBodyPartId = newValue;
      _selectedExerciseId = null;
      _history = [];
    });
  }

  void _onExerciseChanged(String? newValue) {
    if (newValue == _selectedExerciseId) return;

    setState(() {
      _selectedExerciseId = newValue;
    });

    if (newValue != null) {
      _loadHistory(newValue);
    }
  }

  Future<void> _loadHistory(String exerciseId) async {
    final statsProvider = context.read<StatsProvider>();
    final history = await statsProvider.getExerciseHistory(exerciseId);
    
    if (mounted) {
      setState(() {
        _history = history;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final masterProvider = context.watch<MasterProvider>();
    final statsProvider = context.watch<StatsProvider>();
    
    final bodyParts = masterProvider.bodyParts;
    List<Exercise> exercises = [];
    
    if (_selectedBodyPartId != null) {
      exercises = masterProvider.getExercisesForBodyPart(_selectedBodyPartId!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('統計'),
      ),
      body: Column(
        children: [
          // Selectors
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '部位',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: _selectedBodyPartId,
                    items: bodyParts.map((bp) {
                      return DropdownMenuItem(
                        value: bp.id,
                        child: Text(bp.name),
                      );
                    }).toList(),
                    onChanged: _onBodyPartChanged,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '種目',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: _selectedExerciseId,
                    items: exercises.map((e) {
                      return DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: _onBodyPartChanged != null ? _onExerciseChanged : null,
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: _selectedExerciseId == null
                ? const Center(child: Text('種目を選択してください'))
                : statsProvider.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : _history.isEmpty
                        ? const Center(child: Text('データがありません'))
                        : _buildStatsContent(statsProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(StatsProvider statsProvider) {
    // 1. Filter history based on selected period
    final now = DateTime.now();
    final cutoffDate = _selectedPeriod == 0 
        ? null 
        : now.subtract(Duration(days: _selectedPeriod));

    final filteredHistory = _history.where((record) {
      if (cutoffDate == null) return true;
      final dateKey = record['workoutDateKey'] as String;
      final date = DateHelper.fromDateKey(dateKey);
      // Include data on the cutoff date
      return date.isAfter(cutoffDate) || DateHelper.isSameDay(date, cutoffDate);
    }).toList();

    // Sort by date ascending (oldest to newest)
    filteredHistory.sort((a, b) {
      final dateA = DateHelper.fromDateKey(a['workoutDateKey'] as String);
      final dateB = DateHelper.fromDateKey(b['workoutDateKey'] as String);
      return dateA.compareTo(dateB);
    });

    // 2. Aggregate data by date (Daily Max) for the Graph
    final Map<DateTime, double> dailyMaxWeights = {};
    for (var record in filteredHistory) {
      final dateKey = record['workoutDateKey'] as String;
      final date = DateHelper.fromDateKey(dateKey); // Time is 00:00:00
      
      double recordMax = 0;
      final sets = record['sets'] as List;
      for (var set in sets) {
        final weight = (set['weight'] as num).toDouble();
        if (weight > recordMax) recordMax = weight;
      }

      if (!dailyMaxWeights.containsKey(date) || recordMax > dailyMaxWeights[date]!) {
        dailyMaxWeights[date] = recordMax;
      }
    }

    final sortedEntries = dailyMaxWeights.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // 3. Create Spots with time-based X-axis
    double overallMaxWeight = 0;
    double minWeightRecord = double.infinity;
    List<FlSpot> spots = [];
    DateTime? baseDate;

    if (sortedEntries.isNotEmpty) {
      baseDate = sortedEntries.first.key;

      for (var entry in sortedEntries) {
        final date = entry.key;
        final weight = entry.value;

        if (weight > overallMaxWeight) overallMaxWeight = weight;
        if (weight < minWeightRecord) minWeightRecord = weight;

        // X = Days since baseDate
        final xVal = date.difference(baseDate).inDays.toDouble();
        spots.add(FlSpot(xVal, weight));
      }
    }

    if (minWeightRecord == double.infinity) minWeightRecord = 0;

    // Y Axis Config
    double minY = (minWeightRecord - 10) > 0 ? (minWeightRecord - 10) : 0;
    double maxY = overallMaxWeight * 1.1;
    if (maxY == 0) maxY = 10;

    // X Axis Config
    double minX = 0;
    double maxX = 0;
    if (spots.isNotEmpty) {
      maxX = spots.last.x;
    }
    // Add some padding to X axis if needed, or keep it tight
    double xInterval = maxX > 5 ? (maxX / 5).ceilToDouble() : 1;
    if (xInterval == 0) xInterval = 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Period Selector
          SizedBox(
            width: double.infinity,
            child: CupertinoSegmentedControl<int>(
              children: _periodLabels.map((key, value) => MapEntry(
                key,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(value),
                ),
              )),
              onValueChanged: (value) {
                setState(() {
                  _selectedPeriod = value;
                });
              },
              groupValue: _selectedPeriod,
              selectedColor: AppConstants.primaryColor,
              borderColor: AppConstants.primaryColor,
              pressedColor: AppConstants.primaryColor.withAlpha(50),
            ),
          ),
          const SizedBox(height: 24),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Max Weight',
                  '${overallMaxWeight.toStringAsFixed(1)} kg',
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Graph
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Max Weight 推移',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: spots.isEmpty 
                  ? const Center(child: Text('期間内のデータがありません'))
                  : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[200],
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            interval: xInterval,
                            getTitlesWidget: (value, meta) {
                              if (baseDate == null) return const SizedBox();
                              
                              // Calculate date from baseDate + value (days)
                              final date = baseDate.add(Duration(days: value.toInt()));
                              
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${date.month}/${date.day}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            },
                            reservedSize: 28,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: minY,
                      maxY: maxY,
                      minX: minX,
                      maxX: maxX,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: AppConstants.primaryColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppConstants.primaryColor.withAlpha(50),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              if (baseDate == null) return null;
                              final date = baseDate.add(Duration(days: spot.x.toInt()));
                              final dateStr = DateHelper.formatDisplayDate(date);
                              
                              return LineTooltipItem(
                                '$dateStr\n${spot.y} kg',
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // History List
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '履歴',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredHistory.length,
            itemBuilder: (context, index) {
              final record = filteredHistory[filteredHistory.length - 1 - index];
              final dateKey = record['workoutDateKey'] as String;
              final sets = record['sets'] as List;
              final date = DateHelper.fromDateKey(dateKey);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateHelper.formatDisplayDate(date),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sets.map((set) {
                          final weight = (set['weight'] as num).toDouble();
                          final reps = set['reps'] as int;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${weight}kg × $reps',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
