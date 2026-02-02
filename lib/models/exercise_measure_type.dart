enum ExerciseMeasureType {
  weightReps, // 重量 × 回数（ベンチプレス、スクワット等）
  time, // 時間（プランク、Lシット等）
  repsOnly, // 回数のみ（自重スクワット、懸垂等）
}

extension ExerciseMeasureTypeExtension on ExerciseMeasureType {
  String get displayName {
    switch (this) {
      case ExerciseMeasureType.weightReps:
        return '重量×回数';
      case ExerciseMeasureType.time:
        return '時間';
      case ExerciseMeasureType.repsOnly:
        return '回数のみ';
    }
  }

  String toFirestore() {
    return name; // 'weightReps' or 'time'
  }

  static ExerciseMeasureType fromFirestore(String value) {
    return ExerciseMeasureType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExerciseMeasureType.weightReps, // デフォルト
    );
  }
}
