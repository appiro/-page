class WorkoutSet {
  final double weight;
  final int reps;
  final bool assisted;
  final String? setMemo;

  WorkoutSet({
    required this.weight,
    required this.reps,
    this.assisted = false,
    this.setMemo,
  });

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      weight: (map['weight'] ?? 0.0).toDouble(),
      reps: map['reps'] ?? 0,
      assisted: map['assisted'] ?? false,
      setMemo: map['setMemo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'reps': reps,
      'assisted': assisted,
      if (setMemo != null) 'setMemo': setMemo,
    };
  }

  WorkoutSet copyWith({
    double? weight,
    int? reps,
    bool? assisted,
    String? setMemo,
  }) {
    return WorkoutSet(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      assisted: assisted ?? this.assisted,
      setMemo: setMemo ?? this.setMemo,
    );
  }

  // Calculate volume for this set
  double get volume => weight * reps;
}
