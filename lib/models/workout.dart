import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_item.dart';

class Workout {
  final String id;
  final String workoutDateKey; // 'YYYY-MM-DD' format
  final String title;
  final String note;
  final List<WorkoutItem> items;
  final bool coinGranted; // Prevent double coin award
  final bool isCompleted; // Completion status
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout({
    required this.id,
    required this.workoutDateKey,
    this.title = '',
    this.note = '',
    required this.items,
    this.coinGranted = false,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workout.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      workoutDateKey: data['workoutDateKey'] ?? '',
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      items:
          (data['items'] as List<dynamic>?)
              ?.map((item) => WorkoutItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      coinGranted: data['coinGranted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'workoutDateKey': workoutDateKey,
      'title': title,
      'note': note,
      'items': items.map((item) => item.toMap()).toList(),
      'coinGranted': coinGranted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Workout copyWith({
    String? id,
    String? workoutDateKey,
    String? title,
    String? note,
    List<WorkoutItem>? items,
    bool? coinGranted,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      workoutDateKey: workoutDateKey ?? this.workoutDateKey,
      title: title ?? this.title,
      note: note ?? this.note,
      items: items ?? this.items,
      coinGranted: coinGranted ?? this.coinGranted,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calculate total volume for the entire workout
  double get totalVolume =>
      items.fold(0.0, (total, item) => total + item.totalVolume);

  // Get total number of sets
  int get totalSets => items.fold(0, (total, item) => total + item.sets.length);
}
