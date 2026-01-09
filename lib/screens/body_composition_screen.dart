import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';
import '../utils/date_helper.dart';
import '../providers/stats_provider.dart';
import '../models/body_composition_entry.dart';

class BodyCompositionScreen extends StatefulWidget {
  const BodyCompositionScreen({super.key});

  @override
  State<BodyCompositionScreen> createState() => _BodyCompositionScreenState();
}

class _BodyCompositionScreenState extends State<BodyCompositionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriodIndex = 1; // 0:7日, 1:30日, 2:90日, 3:全期間
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体組成記録'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: '入力'),
            Tab(icon: Icon(Icons.show_chart), text: 'グラフ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInputTab(),
          _buildGraphTab(),
        ],
      ),
    );
  }

  Widget _buildGraphTab() {
    return Column(
      children: [
        // Period selector
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('期間: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPeriodChip('7日', 0),
                      const SizedBox(width: 8),
                      _buildPeriodChip('30日', 1),
                      const SizedBox(width: 8),
                      _buildPeriodChip('90日', 2),
                      const SizedBox(width: 8),
                      _buildPeriodChip('全期間', 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<BodyCompositionEntry>>(
            stream: context.read<StatsProvider>().bodyCompositionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allData = snapshot.data ?? [];
              final filteredData = _filterDataByPeriod(allData);

              if (filteredData.isEmpty) {
                return const Center(
                  child: Text('データがありません\n入力タブから記録を追加してください'),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWeightChart(filteredData),
                    const Divider(height: 32),
                    _buildBodyFatChart(filteredData),
                    const Divider(height: 32),
                    _buildMuscleChart(filteredData),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodChip(String label, int index) {
    final isSelected = _selectedPeriodIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPeriodIndex = index;
          });
        }
      },
    );
  }

  List<BodyCompositionEntry> _filterDataByPeriod(List<BodyCompositionEntry> data) {
    List<BodyCompositionEntry> filtered;
    
    if (_selectedPeriodIndex == 3) {
      filtered = data; // 全期間
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final days = _selectedPeriodIndex == 0 ? 7 : (_selectedPeriodIndex == 1 ? 30 : 90);
      // 今日を含めてN日間なので、N-1日前から今日まで
      final cutoffDate = today.subtract(Duration(days: days - 1));

      filtered = data.where((entry) {
        final entryDate = DateHelper.fromDateKey(entry.dateKey);
        // cutoffDate以降（cutoffDateを含む）のデータを含める
        return !entryDate.isBefore(cutoffDate) && !entryDate.isAfter(today);
      }).toList();
    }

    // 重複排除: dateKeyが同じならupdatedAtが新しい方を採用
    final uniqueMap = <String, BodyCompositionEntry>{};
    for (final entry in filtered) {
      if (!uniqueMap.containsKey(entry.dateKey) || 
          entry.updatedAt.isAfter(uniqueMap[entry.dateKey]!.updatedAt)) {
        uniqueMap[entry.dateKey] = entry;
      }
    }
    
    return uniqueMap.values.toList();
  }

  Widget _buildWeightChart(List<BodyCompositionEntry> data) {
    return _buildChart(
      title: '体重 (kg)',
      data: data,
      getValue: (entry) => entry.weight,
      color: Colors.blue,
      minY: _calculateMinY(data.map((e) => e.weight).toList()),
      maxY: _calculateMaxY(data.map((e) => e.weight).toList()),
    );
  }

  Widget _buildBodyFatChart(List<BodyCompositionEntry> data) {
    final values = data.where((e) => e.bodyFatPercentage != null).map((e) => e.bodyFatPercentage!).toList();
    if (values.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('体脂肪率のデータがありません', style: TextStyle(color: Colors.grey)),
      );
    }

    return _buildChart(
      title: '体脂肪率 (%)',
      data: data,
      getValue: (entry) => entry.bodyFatPercentage,
      color: Colors.orange,
      minY: _calculateMinY(values),
      maxY: _calculateMaxY(values),
    );
  }

  Widget _buildMuscleChart(List<BodyCompositionEntry> data) {
    final values = data.where((e) => e.muscleMass != null).map((e) => e.muscleMass!).toList();
    if (values.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('筋肉量のデータがありません', style: TextStyle(color: Colors.grey)),
      );
    }

    return _buildChart(
      title: '筋肉量 (kg)',
      data: data,
      getValue: (entry) => entry.muscleMass,
      color: Colors.green,
      minY: _calculateMinY(values),
      maxY: _calculateMaxY(values),
    );
  }

  double _calculateMinY(List<double> values) {
    if (values.isEmpty) return 0;
    final min = values.reduce((a, b) => a < b ? a : b);
    return (min * 0.95).floorToDouble();
  }

  double _calculateMaxY(List<double> values) {
    if (values.isEmpty) return 100;
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max * 1.05).ceilToDouble();
  }

  Widget _buildChart({
    required String title,
    required List<BodyCompositionEntry> data,
    required double? Function(BodyCompositionEntry) getValue,
    required Color color,
    required double minY,
    required double maxY,
  }) {
    final spots = <FlSpot>[];
    final sortedData = List<BodyCompositionEntry>.from(data)
      ..sort((a, b) => a.dateKey.compareTo(b.dateKey));

    for (int i = 0; i < sortedData.length; i++) {
      final value = getValue(sortedData[i]);
      if (value != null) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    if (spots.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 4,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= sortedData.length) {
                          return const Text('');
                        }
                        
                        // データポイント数に応じて表示間隔を調整
                        final dataLength = sortedData.length;
                        int interval;
                        if (dataLength <= 7) {
                          interval = 1; // 7日以下：全て表示
                        } else if (dataLength <= 14) {
                          interval = 2; // 14日以下：2日おき
                        } else if (dataLength <= 30) {
                          interval = 3; // 30日以下：3日おき
                        } else {
                          interval = 7; // 30日超：7日おき
                        }
                        
                        // 最初、最後、または間隔ごとに表示
                        if (index == 0 || index == dataLength - 1 || index % interval == 0) {
                          final date = DateHelper.fromDateKey(sortedData[index].dateKey);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < sortedData.length) {
                          final entry = sortedData[index];
                          final date = DateHelper.fromDateKey(entry.dateKey);
                          return LineTooltipItem(
                            '${date.month}/${date.day}\n${spot.y.toStringAsFixed(1)}',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTab() {
    return const _InputForm();
  }
}

class _InputForm extends StatefulWidget {
  const _InputForm();

  @override
  State<_InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();
  final TextEditingController _muscleMassController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  final Uuid _uuid = const Uuid();
  bool _isEditing = false;
  BodyCompositionEntry? _todayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodayEntry();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayEntry() async {
    print('Loading today entry...');
    try {
      final provider = context.read<StatsProvider>();
      final dateKey = DateHelper.toDateKey(_selectedDate);
      
      // Get all entries and find today's
      final history = await provider.getBodyCompositionHistory();
      final todayEntry = history.firstWhere(
        (entry) => entry.dateKey == dateKey,
        orElse: () => BodyCompositionEntry(
          id: _uuid.v4(),
          dateKey: dateKey,
          timestamp: _selectedDate,
          weight: 0,
          bodyFatPercentage: null,
          muscleMass: null,
          note: null,
          source: 'manual',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      if (mounted) {
        setState(() {
          _todayEntry = todayEntry;
          if (todayEntry.weight > 0) {
            _weightController.text = todayEntry.weight.toStringAsFixed(1);
            if (todayEntry.bodyFatPercentage != null) {
              _bodyFatController.text = todayEntry.bodyFatPercentage!.toStringAsFixed(1);
            }
            if (todayEntry.muscleMass != null) {
              _muscleMassController.text = todayEntry.muscleMass!.toStringAsFixed(1);
            }
            if (todayEntry.note != null) {
              _memoController.text = todayEntry.note!;
            }
          }
        });
      }
    } catch (e) {
      // If there's an error, create a default entry
      print('Error loading body composition entry: $e');
      if (mounted) {
        final dateKey = DateHelper.toDateKey(_selectedDate);
        setState(() {
          _todayEntry = BodyCompositionEntry(
            id: _uuid.v4(),
            dateKey: dateKey,
            timestamp: _selectedDate,
            weight: 0,
            bodyFatPercentage: null,
            muscleMass: null,
            note: null,
            source: 'manual',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        });
      }
    }
  }

  void _adjustValue(TextEditingController controller, double delta) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = (currentValue + delta).clamp(0.0, 999.9);
    controller.text = newValue.toStringAsFixed(1);
  }

  Future<void> _saveRecord() async {
    final weightText = _weightController.text;
    if (weightText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('体重は必須です')),
      );
      return;
    }

    try {
      final weight = double.parse(weightText);
      
      // Validation
      if (weight <= 0 || weight > 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('体重は0〜300kgの範囲で入力してください')),
        );
        return;
      }

      final bodyFat = _bodyFatController.text.isNotEmpty
          ? double.tryParse(_bodyFatController.text)
          : null;

      if (bodyFat != null && (bodyFat < 0 || bodyFat > 80)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('体脂肪率は0〜80%の範囲で入力してください')),
        );
        return;
      }

      final muscleMass = _muscleMassController.text.isNotEmpty
          ? double.tryParse(_muscleMassController.text)
          : null;

      if (muscleMass != null && (muscleMass <= 0 || muscleMass > 150)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('筋肉量は0〜150kgの範囲で入力してください')),
        );
        return;
      }

      final entry = BodyCompositionEntry(
        id: _uuid.v4(),
        dateKey: DateHelper.toDateKey(_selectedDate),
        timestamp: _selectedDate,
        weight: weight,
        bodyFatPercentage: bodyFat,
        muscleMass: muscleMass,
        note: _memoController.text.isNotEmpty ? _memoController.text : null,
        source: 'manual',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await context.read<StatsProvider>().saveBodyCompositionEntry(entry);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存しました')),
        );
        setState(() {
          _isEditing = false;
        });
        _loadTodayEntry();
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_InputForm build: _todayEntry=${_todayEntry}, isEditing=$_isEditing');
    if (_todayEntry == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isEditing && _todayEntry!.weight > 0) {
      // View mode - show today's record
      return _buildViewMode();
    } else {
      // Edit mode - show input form
      return _buildEditMode();
    }
  }

  Widget _buildViewMode() {
    final entry = _todayEntry!;
    final date = DateHelper.fromDateKey(entry.dateKey);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今日の記録',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateHelper.formatDisplayDate(date),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('編集'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Weight Card
          _buildDataCard(
            icon: Icons.monitor_weight,
            title: '体重',
            value: '${entry.weight.toStringAsFixed(1)} kg',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),

          // Body Fat Card
          if (entry.bodyFatPercentage != null)
            _buildDataCard(
              icon: Icons.pie_chart,
              title: '体脂肪率',
              value: '${entry.bodyFatPercentage!.toStringAsFixed(1)} %',
              color: Colors.orange,
            ),
          if (entry.bodyFatPercentage != null) const SizedBox(height: 16),

          // Muscle Mass Card
          if (entry.muscleMass != null)
            _buildDataCard(
              icon: Icons.fitness_center,
              title: '筋肉量',
              value: '${entry.muscleMass!.toStringAsFixed(1)} kg',
              color: Colors.green,
            ),
          if (entry.muscleMass != null) const SizedBox(height: 16),

          // Note Card
          if (entry.note != null && entry.note!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.note, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text(
                          'メモ',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(entry.note!),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Change date button
          OutlinedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _isEditing = false;
                });
                _loadTodayEntry();
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('別の日の記録を見る'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _todayEntry!.weight > 0 ? '記録を編集' : '新規記録',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (_todayEntry!.weight > 0)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  child: const Text('キャンセル'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Date selector
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('記録日'),
              subtitle: Text(DateHelper.formatDisplayDate(_selectedDate)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                  _loadTodayEntry();
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Weight with +/- buttons
          _buildInputFieldWithButtons(
            label: '体重',
            controller: _weightController,
            unit: 'kg',
            delta: 0.1,
          ),
          const SizedBox(height: 24),

          // Body Fat with +/- buttons
          _buildInputFieldWithButtons(
            label: '体脂肪率',
            controller: _bodyFatController,
            unit: '%',
            delta: 0.1,
          ),
          const SizedBox(height: 24),

          // Muscle Mass with +/- buttons
          _buildInputFieldWithButtons(
            label: '筋肉量',
            controller: _muscleMassController,
            unit: 'kg',
            delta: 0.1,
          ),
          const SizedBox(height: 24),

          // Memo
          Text(
            'メモ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _memoController,
            decoration: const InputDecoration(
              labelText: 'メモ（任意）',
              hintText: '体調、気づいたことなど...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveRecord,
              icon: const Icon(Icons.save),
              label: const Text('保存'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldWithButtons({
    required String label,
    required TextEditingController controller,
    required String unit,
    required double delta,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Minus button
            IconButton(
              onPressed: () => _adjustValue(controller, -delta),
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              iconSize: 32,
            ),
            const SizedBox(width: 8),
            // Input field
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: '$label ($unit)',
                  border: const OutlineInputBorder(),
                  suffixText: unit,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            // Plus button
            IconButton(
              onPressed: () => _adjustValue(controller, delta),
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.green,
              iconSize: 32,
            ),
          ],
        ),
      ],
    );
  }
}
