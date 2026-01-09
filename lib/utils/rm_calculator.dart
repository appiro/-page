class RMCalculator {
  // Calculate estimated 1RM using Epley formula
  // Formula: weight × (1 + reps/30)
  static double calculateOneRepMax(double weight, int reps) {
    if (reps == 0) return 0.0;
    if (reps == 1) return weight;
    
    return weight * (1 + reps / 30);
  }

  // Calculate multiple 1RM estimates from a list of sets
  static List<double> calculateMultipleRMs(List<Map<String, dynamic>> sets) {
    return sets.map((set) {
      final weight = (set['weight'] ?? 0.0).toDouble();
      final reps = set['reps'] ?? 0;
      return calculateOneRepMax(weight, reps);
    }).toList();
  }

  // Get the highest estimated 1RM from a list of sets
  static double getMaxRM(List<Map<String, dynamic>> sets) {
    if (sets.isEmpty) return 0.0;
    
    final rms = calculateMultipleRMs(sets);
    return rms.reduce((a, b) => a > b ? a : b);
  }

  // Format RM for display with unit
  static String formatRM(double rm, String unit) {
    return '${rm.toStringAsFixed(1)} $unit';
  }
}
