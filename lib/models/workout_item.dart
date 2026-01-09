import 'workout_set.dart';
import 'dart:math';

class WorkoutItem {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final String bodyPartId;
  final String bodyPartName;
  final List<WorkoutSet> sets;
  final String memo;
  final int order;

  WorkoutItem({
    String? id,
    required this.exerciseId,
    required this.exerciseName,
    required this.bodyPartId,
    required this.bodyPartName,
    required this.sets,
    this.memo = '',
    required this.order,
  }) : id = id ?? (DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(10000).toString());

  factory WorkoutItem.fromMap(Map<String, dynamic> map) {
    return WorkoutItem(
      id: map['id'], // If null, new ID will be generated
      exerciseId: map['exerciseId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      bodyPartId: map['bodyPartId'] ?? '',
      bodyPartName: map['bodyPartName'] ?? '',
      sets: (map['sets'] as List<dynamic>?)
              ?.map((s) => WorkoutSet.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      memo: map['memo'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'bodyPartId': bodyPartId,
      'bodyPartName': bodyPartName,
      'sets': sets.map((s) => s.toMap()).toList(),
      'memo': memo,
      'order': order,
    };
  }

  WorkoutItem copyWith({
    String? id,
    String? exerciseName,
    String? bodyPartId,
    String? bodyPartName,
    List<WorkoutSet>? sets,
    String? memo,
    int? order,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      exerciseId: exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      bodyPartId: bodyPartId ?? this.bodyPartId,
      bodyPartName: bodyPartName ?? this.bodyPartName,
      sets: sets ?? this.sets,
      memo: memo ?? this.memo,
      order: order ?? this.order,
    );
  }

  // Calculate total volume for this exercise
  double get totalVolume => sets.fold(0.0, (sum, set) => sum + set.volume);
}
