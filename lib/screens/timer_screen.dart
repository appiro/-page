import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';
import '../services/notification_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 60;
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;
  final List<int> _presetTimes = [30, 45, 60, 90, 120, 180];

  // Custom Input Controllers
  late FixedExtentScrollController _minScrollCtrl;
  late FixedExtentScrollController _secScrollCtrl;
  late TextEditingController _minTextCtrl;
  late TextEditingController _secTextCtrl;

  @override
  void initState() {
    super.initState();
    _minTextCtrl = TextEditingController();
    _secTextCtrl = TextEditingController();
    _updateControllersFromSeconds();
  }

  void _updateControllersFromSeconds() {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    _minScrollCtrl = FixedExtentScrollController(initialItem: m);
    // Seconds picker is 5-second steps steps, so divide by 5
    _secScrollCtrl = FixedExtentScrollController(initialItem: (s / 5).round());
    
    _minTextCtrl.text = m.toString();
    _secTextCtrl.text = s.toString();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _minScrollCtrl.dispose();
    _secScrollCtrl.dispose();
    _minTextCtrl.dispose();
    _secTextCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _remainingSeconds = _seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
          _onTimerComplete();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _seconds;
    });
  }

  void _onTimerComplete() {
    // Show notification
    NotificationService().showTimerNotification(_seconds);

    // Vibrate device (pulsing feedback)
    _vibrateAlert();

    // Show dialog
    if (mounted) {
      showDialog(
        context: context,
          builder: (dialogContext) => AlertDialog(
          title: const Text('タイマー終了！'),
          content: const Text('インターバルが終了しました'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                _resetTimer();
                if (mounted) {
                  Navigator.of(context).pop(); // Close screen (return to editor)
                }
              },
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
                _startTimer();
              },
              child: const Text('もう一度'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _vibrateAlert() async {
    // Simple pulsing vibration using HapticFeedback
    for (int i = 0; i < 5; i++) {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatPresetLabel(int totalSeconds) {
    if (totalSeconds < 60) return '$totalSeconds秒';
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    if (s == 0) return '$m分';
    return '$m分$s秒';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _seconds > 0 ? _remainingSeconds / _seconds : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('インターバルタイマー'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer Display
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isRunning ? AppConstants.primaryColor : Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 64,
                            ),
                      ),
                      if (_isRunning)
                        Text(
                          '残り時間',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Control Buttons
              if (!_isRunning) ...[
                // Start Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.play_arrow, size: 32),
                    label: const Text(
                      'スタート',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: AppConstants.successColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                // Stop and Reset Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child: OutlinedButton.icon(
                        onPressed: _stopTimer,
                        icon: const Icon(Icons.pause),
                        label: const Text('停止'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 120,
                      child: OutlinedButton.icon(
                        onPressed: _resetTimer,
                        icon: const Icon(Icons.refresh),
                        label: const Text('リセット'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 48),

              // Time Presets
              if (!_isRunning) ...[
                Text(
                  'プリセット',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: _presetTimes.map((time) {
                    final isSelected = _seconds == time;
                    
                    // Format Label
                    String label;
                    if (time < 60) {
                      label = '${time}秒';
                    } else {
                      final m = time ~/ 60;
                      final s = time % 60;
                      label = s == 0 ? '${m}分' : '${m}分${s}秒';
                    }

                    return ChoiceChip(
                      label: Text(
                        label,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _seconds = time;
                            _remainingSeconds = time;
                            
                            // Sync controllers
                            final m = time ~/ 60;
                            final s = time % 60;
                            if (_minScrollCtrl.hasClients) _minScrollCtrl.jumpToItem(m);
                            if (_secScrollCtrl.hasClients) _secScrollCtrl.jumpToItem((s / 5).round());
                            _minTextCtrl.text = m.toString();
                            _secTextCtrl.text = s.toString();
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Custom Time Input
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'カスタム設定',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Pickers
                        SizedBox(
                          height: 120,
                          child: Row(
                            children: [
                              // Minutes Picker
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: _minScrollCtrl,
                                  itemExtent: 32,
                                  onSelectedItemChanged: (index) {
                                    _minTextCtrl.text = index.toString();
                                  },
                                  children: List.generate(100, (index) => Center(child: Text('$index'))),
                                ),
                              ),
                              const Text('分', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              
                              // Seconds Picker (0, 5, 10... 55)
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: _secScrollCtrl,
                                  itemExtent: 32,
                                  onSelectedItemChanged: (index) {
                                    final val = index * 5;
                                    _secTextCtrl.text = val.toString();
                                  },
                                  children: List.generate(12, (index) => Center(child: Text('${index * 5}'))),
                                ),
                              ),
                              const Text('秒', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Manual Input
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minTextCtrl,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  labelText: '分',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (val) {
                                  final m = int.tryParse(val);
                                  if (m != null && m >= 0 && m < 100) {
                                    if (_minScrollCtrl.hasClients) _minScrollCtrl.jumpToItem(m);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _secTextCtrl,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  labelText: '秒',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (val) {
                                  final s = int.tryParse(val);
                                  // Sync picker to nearest 5 multiple
                                  if (s != null && s >= 0 && s < 60) {
                                     // Picker index = s / 5
                                     if (_secScrollCtrl.hasClients) _secScrollCtrl.jumpToItem((s / 5).round());
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  final m = int.tryParse(_minTextCtrl.text) ?? 0;
                                  final s = int.tryParse(_secTextCtrl.text) ?? 0;
                                  final total = m * 60 + s;
                                  if (total > 0) {
                                    setState(() {
                                      _seconds = total;
                                      _remainingSeconds = total;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('タイマーを ${_formatPresetLabel(total)} に設定しました')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('設定を保存'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
