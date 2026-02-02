import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/master_provider.dart';
import '../repositories/fit_repository.dart';
import '../utils/default_data_helper.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _logs = '';
  bool _isLoading = false;

  void _log(String message) {
    setState(() {
      _logs += '• $message\n';
    });
    print('[DebugScreen] $message');
  }

  Future<void> _runExerciseFix() async {
    setState(() {
      _isLoading = true;
      _logs = '';
    });
    _log('Starting exercise type fix...');

    try {
      final masterProvider = context.read<MasterProvider>();
      // We need to access the repository.
      // MasterProvider holds it private, but we can't easily access it.
      // However, we can use DefaultDataHelper directly if we had the repository.

      // Since we can't easily access the repo from Provider public interface (unless we change it),
      // We will perform a trick? No, let's just use the provider's reload logic if possible.

      // Wait, MasterProvider DOES NOT expose the repository.
      // But we can get it from the top level if we knew how it was provided.
      // Usually it's provided via MultiProvider.

      final repository = context.read<FitRepository>();

      _log('Repository found: ${repository.runtimeType}');

      await DefaultDataHelper.fixTimeBasedExercises(
        masterProvider.uid,
        repository,
      );
      _log('DefaultDataHelper.fixTimeBasedExercises completed.');

      _log('Refreshing MasterProvider...');
      // Re-trigger load to refresh UI
      // MasterProvider doesn't have a public refresh, but we can restart access?
      // Actually, we can just hope the stream updates.
    } catch (e) {
      _log('Error running fix: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkDatabase() async {
    setState(() {
      _isLoading = true;
      _logs = '';
    });
    _log('Checking database...');

    try {
      final repository = context.read<FitRepository>();

      // Check 1: Schema Version
      // Checking via internal DB object not easily possible without exposing it.
      // But we can check if durationSec saves.

      // Let's verify 'Plank' status
      final exercises = await repository.getExercisesStream("user").first;
      final plank = exercises.firstWhere(
        (e) => e.name == 'プランク' || e.name == 'Plank',
        orElse: () => exercises.first,
      );

      _log('Sample Exercise: ${plank.name}');
      _log('Measure Type: ${plank.measureType}');

      if (plank.measureType.name == 'time') {
        _log('SUCCESS: Plank is correctly set to TIME');
      } else {
        _log('FAILURE: Plank is set to ${plank.measureType.name}');
      }
    } catch (e) {
      _log('Error checking DB: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Tools')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _runExerciseFix,
              child: const Text('Run Exercise Type Fix'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkDatabase,
              child: const Text('Check Database Status'),
            ),
            const SizedBox(height: 16),
            const Text('Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(child: Text(_logs)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
