import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String unit; // 'kg' or 'lbs'
  final int weeklyGoal;
  final String weekStartsOn; // 'mon', 'sun', etc.
  final DateTime? weeklyGoalUpdatedAt;
  final bool vibrationOn;
  final bool notificationsOn;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.unit = 'kg',
    this.weeklyGoal = 3,
    this.weekStartsOn = 'mon',
    this.weeklyGoalUpdatedAt,
    this.vibrationOn = true,
    this.notificationsOn = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      unit: data['unit'] ?? 'kg',
      weeklyGoal: data['weeklyGoal'] ?? 3,
      weekStartsOn: data['weekStartsOn'] ?? 'mon',
      weeklyGoalUpdatedAt: data['weeklyGoalUpdatedAt'] != null 
          ? (data['weeklyGoalUpdatedAt'] as Timestamp).toDate() 
          : null,
      vibrationOn: data['vibrationOn'] ?? true,
      notificationsOn: data['notificationsOn'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'unit': unit,
      'weeklyGoal': weeklyGoal,
      'weekStartsOn': weekStartsOn,
      'weeklyGoalUpdatedAt': weeklyGoalUpdatedAt != null 
          ? Timestamp.fromDate(weeklyGoalUpdatedAt!) 
          : null,
      'vibrationOn': vibrationOn,
      'notificationsOn': notificationsOn,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? unit,
    int? weeklyGoal,
    String? weekStartsOn,
    DateTime? weeklyGoalUpdatedAt,
    bool? vibrationOn,
    bool? notificationsOn,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      unit: unit ?? this.unit,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      weekStartsOn: weekStartsOn ?? this.weekStartsOn,
      weeklyGoalUpdatedAt: weeklyGoalUpdatedAt ?? this.weeklyGoalUpdatedAt,
      vibrationOn: vibrationOn ?? this.vibrationOn,
      notificationsOn: notificationsOn ?? this.notificationsOn,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
