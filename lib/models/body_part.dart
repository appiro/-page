import 'package:cloud_firestore/cloud_firestore.dart';

class BodyPart {
  final String id;
  final String name;
  final int order;
  final DateTime createdAt;
  final bool isArchived;

  BodyPart({
    required this.id,
    required this.name,
    required this.order,
    required this.createdAt,
    this.isArchived = false,
  });

  factory BodyPart.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BodyPart(
      id: doc.id,
      name: data['name'] ?? '',
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isArchived: data['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'order': order,
      'createdAt': Timestamp.fromDate(createdAt),
      'isArchived': isArchived,
    };
  }

  BodyPart copyWith({
    String? name,
    int? order,
    bool? isArchived,
  }) {
    return BodyPart(
      id: id,
      name: name ?? this.name,
      order: order ?? this.order,
      createdAt: createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
