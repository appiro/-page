import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final String bodyPartId;
  final int order;
  final bool isArchived;
  final DateTime createdAt;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPartId,
    required this.order,
    this.isArchived = false,
    required this.createdAt,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'bodyPartId': bodyPartId,
      'order': order,
      'isArchived': isArchived,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Exercise copyWith({
    String? name,
    String? bodyPartId,
    int? order,
    bool? isArchived,
  }) {
    return Exercise(
      id: id,
      name: name ?? this.name,
      bodyPartId: bodyPartId ?? this.bodyPartId,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
    );
  }
}
