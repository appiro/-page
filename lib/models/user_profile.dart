import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String unit; // 'kg' or 'lbs'
  final int weeklyGoal;
  final DateTime? weeklyGoalAnchor; // Anchored start date for 7-day cycles
  final int
  lastRewardedCycleIndex; // To track if user got reward for current cycle
  final DateTime? weeklyGoalUpdatedAt;
  final bool vibrationOn;
  final bool notificationsOn;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> seenTutorials;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.unit = 'kg',
    this.weeklyGoal = 3,
    this.weeklyGoalAnchor,
    this.lastRewardedCycleIndex = -1,
    this.weeklyGoalUpdatedAt,
    this.vibrationOn = true,
    this.notificationsOn = true,
    required this.createdAt,
    required this.updatedAt,
    List<String>? seenTutorials,
  }) : seenTutorials = seenTutorials ?? [];

  // Backward compatibility getter
  bool get tutorialSeen => seenTutorials.contains('home');

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final now = DateTime.now();

    // Migration: Check for new list field, fallback to old boolean
    List<String> tutorials = [];
    if (data['seenTutorials'] != null) {
      tutorials = List<String>.from(data['seenTutorials']);
    } else if (data['tutorialSeen'] == true) {
      tutorials = ['home'];
    }

    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      unit: data['unit'] ?? 'kg',
      weeklyGoal: data['weeklyGoal'] ?? 3,
      weeklyGoalAnchor: data['weeklyGoalAnchor'] != null
          ? (data['weeklyGoalAnchor'] as Timestamp).toDate()
          : null,
      lastRewardedCycleIndex: data['lastRewardedCycleIndex'] ?? -1,
      weeklyGoalUpdatedAt: data['weeklyGoalUpdatedAt'] != null
          ? (data['weeklyGoalUpdatedAt'] as Timestamp).toDate()
          : null,
      vibrationOn: data['vibrationOn'] ?? true,
      notificationsOn: data['notificationsOn'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : now,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : now,
      seenTutorials: tutorials,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'unit': unit,
      'weeklyGoal': weeklyGoal,
      'weeklyGoalAnchor': weeklyGoalAnchor != null
          ? Timestamp.fromDate(weeklyGoalAnchor!)
          : null,
      'lastRewardedCycleIndex': lastRewardedCycleIndex,
      'weeklyGoalUpdatedAt': weeklyGoalUpdatedAt != null
          ? Timestamp.fromDate(weeklyGoalUpdatedAt!)
          : null,
      'vibrationOn': vibrationOn,
      'notificationsOn': notificationsOn,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'seenTutorials': seenTutorials,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? unit,
    int? weeklyGoal,
    DateTime? weeklyGoalAnchor,
    int? lastRewardedCycleIndex,
    DateTime? weeklyGoalUpdatedAt,
    bool? vibrationOn,
    bool? notificationsOn,
    DateTime? updatedAt,
    List<String>? seenTutorials,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      unit: unit ?? this.unit,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      weeklyGoalAnchor: weeklyGoalAnchor ?? this.weeklyGoalAnchor,
      lastRewardedCycleIndex:
          lastRewardedCycleIndex ?? this.lastRewardedCycleIndex,
      weeklyGoalUpdatedAt: weeklyGoalUpdatedAt ?? this.weeklyGoalUpdatedAt,
      vibrationOn: vibrationOn ?? this.vibrationOn,
      notificationsOn: notificationsOn ?? this.notificationsOn,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seenTutorials: seenTutorials ?? this.seenTutorials,
    );
  }
}
