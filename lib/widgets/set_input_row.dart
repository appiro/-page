import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/workout_set.dart';
import '../utils/constants.dart';

class SetInputRow extends StatefulWidget {
  final WorkoutSet set;
  final int setNumber;
  final String unit;
  final Function(WorkoutSet) onChanged;
  final VoidCallback onDelete;
  final bool autoFocus;

  const SetInputRow({
    super.key,
    required this.set,
    required this.setNumber,
    required this.unit,
    required this.onChanged,
    required this.onDelete,
    this.autoFocus = false,
  });

  @override
  State<SetInputRow> createState() => _SetInputRowState();
}

class _SetInputRowState extends State<SetInputRow> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late bool _assisted;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.set.weight > 0 ? widget.set.weight.toString() : '',
    );
    _repsController = TextEditingController(
      text: widget.set.reps > 0 ? widget.set.reps.toString() : '',
    );
    _assisted = widget.set.assisted;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final reps = int.tryParse(_repsController.text) ?? 0;
    
    widget.onChanged(WorkoutSet(
      weight: weight,
      reps: reps,
      assisted: _assisted,
      setMemo: widget.set.setMemo,
    ));
  }

  @override
  void didUpdateWidget(SetInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync Weight Controller if value changed externally significantly
    final currentWeight = double.tryParse(_weightController.text) ?? 0.0;
    if ((currentWeight - widget.set.weight).abs() > 0.001) {
      String text = widget.set.weight > 0 ? widget.set.weight.toString() : '';
      if (text.endsWith('.0')) {
        text = text.substring(0, text.length - 2);
      }
      // Only update if the string representation is actually different to avoid cursor jumps
      // (Though the numeric check above handles most cases, explicit text mismatch check is safer)
      if (_weightController.text != text) {
        _weightController.text = text;
      }
    }

    // Sync Reps Controller
    final currentReps = int.tryParse(_repsController.text) ?? 0;
    if (currentReps != widget.set.reps) {
      final text = widget.set.reps > 0 ? widget.set.reps.toString() : '';
      if (_repsController.text != text) {
        _repsController.text = text;
      }
    }

    // Sync Assisted
    if (_assisted != widget.set.assisted) {
      setState(() {
        _assisted = widget.set.assisted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Set Number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${widget.setNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Weight Input
            Expanded(
              flex: 2,
              child: TextField(
                controller: _weightController,
                autofocus: widget.autoFocus,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  labelText: widget.unit,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (_) => _notifyChange(),
              ),
            ),
            const SizedBox(width: 8),

            // Reps Input
            Expanded(
              flex: 2,
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (_) => _notifyChange(),
              ),
            ),
            const SizedBox(width: 8),

            // Assisted Checkbox
            SizedBox(
              width: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '補助',
                    style: TextStyle(fontSize: 10),
                  ),
                  Checkbox(
                    value: _assisted,
                    onChanged: (value) {
                      setState(() {
                        _assisted = value ?? false;
                      });
                      _notifyChange();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: widget.onDelete,
              constraints: const BoxConstraints(
                minWidth: AppConstants.minTapTargetSize,
                minHeight: AppConstants.minTapTargetSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

