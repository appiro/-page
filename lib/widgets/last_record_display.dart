import 'package:flutter/material.dart';

class LastRecordDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> lastRecord;
  final String unit;
  final VoidCallback onCopy;

  const LastRecordDisplay({
    super.key,
    required this.lastRecord,
    required this.unit,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    if (lastRecord.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '前回の記録',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
              TextButton.icon(
                onPressed: onCopy,
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('コピー'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: lastRecord.map((set) {
              final weight = set['weight'] as num?;
              final reps = set['reps'] as int?;
              final duration = set['durationSec'] as int?;
              final assisted = set['assisted'] as bool? ?? false;

              String labelText;
              if (duration != null && duration > 0) {
                labelText = '${duration}秒${assisted ? ' (A)' : ''}';
              } else {
                final w = (weight ?? 0).toDouble();
                final r = reps ?? 0;
                labelText =
                    '${w.toStringAsFixed(w.truncateToDouble() == w ? 0 : 1)}$unit × $r${assisted ? ' (A)' : ''}';
              }

              return Chip(
                label: Text(labelText, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
