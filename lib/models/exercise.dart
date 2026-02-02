import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_measure_type.dart';

class Exercise {
  final String id;
  final String name;
  final String bodyPartId;
  final int order;
  final bool isArchived;
  final DateTime createdAt;
  final ExerciseMeasureType measureType;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPartId,
    required this.order,
    this.isArchived = false,
    required this.createdAt,
    this.measureType = ExerciseMeasureType.weightReps,
  });

  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id,
      name: data['name'] ?? '',
      bodyPartId: data['bodyPartId'] ?? '',
      order: data['order'] ?? 0,
      isArchived: data['isArchived'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      measureType: data['measureType'] != null
          ? ExerciseMeasureTypeExtension.fromFirestore(data['measureType'])
          : ExerciseMeasureType.weightReps,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'bodyPartId': bodyPartId,
      'order': order,
      'isArchived': isArchived,
      'createdAt': Timestamp.fromDate(createdAt),
      'measureType': measureType.toFirestore(),
    };
  }

  Exercise copyWith({
    String? name,
    String? bodyPartId,
    int? order,
    bool? isArchived,
    ExerciseMeasureType? measureType,
  }) {
    return Exercise(
      id: id,
      name: name ?? this.name,
      bodyPartId: bodyPartId ?? this.bodyPartId,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
      measureType: measureType ?? this.measureType,
    );
  }
}
