class WorkoutSet {
  final String localId;
  final double? weight;
  final int? reps;
  final int? durationSec;
  final bool assisted;
  final String? setMemo;

  WorkoutSet({
    String? localId,
    this.weight,
    this.reps,
    this.durationSec,
    this.assisted = false,
    this.setMemo,
  }) : localId = localId ?? DateTime.now().microsecondsSinceEpoch.toString();

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      weight: map['weight']?.toDouble(),
      reps: map['reps'],
      durationSec: map['durationSec'],
      assisted: map['assisted'] ?? false,
      setMemo: map['setMemo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (durationSec != null) 'durationSec': durationSec,
      'assisted': assisted,
      if (setMemo != null) 'setMemo': setMemo,
    };
  }

  WorkoutSet copyWith({
    String? localId,
    double? weight,
    int? reps,
    int? durationSec,
    bool? assisted,
    String? setMemo,
  }) {
    return WorkoutSet(
      localId: localId ?? this.localId,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      durationSec: durationSec ?? this.durationSec,
      assisted: assisted ?? this.assisted,
      setMemo: setMemo ?? this.setMemo,
    );
  }

  // Calculate volume for this set
  // time系セットはvolume計算に含めない（0を返す）
  double get volume {
    if (weight != null && reps != null) {
      return weight! * reps!.toDouble();
    }
    return 0.0;
  }
}
