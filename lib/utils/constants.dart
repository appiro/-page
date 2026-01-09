import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Fit App';
  static const String appVersion = '1.0.0';

  // Default Settings
  static const String defaultUnit = 'kg';
  static const int defaultWeeklyGoal = 3;
  static const String defaultWeekStartsOn = 'mon';
  static const int defaultTimerSeconds = 90;

  // Economy
  static const int weeklyGoalBonusCoins = 100;
  static const double coinMultiplier = 1.0; // Can adjust coin earning rate

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double minTapTargetSize = 48.0;

  // Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);

  // Achievement Keys
  static const String achievementWeeklyGoal = 'weeklyGoalAchieved';
  static const String achievementTotalWorkouts = 'totalWorkouts';
  static const String achievementTotalCoins = 'totalCoinsEarned';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String workoutsSubcollection = 'workouts';
  static const String bodyPartsSubcollection = 'bodyParts';
  static const String exercisesSubcollection = 'exercises';
  static const String economyDocument = 'economy';

  // Error Messages
  static const String errorNetworkUnavailable = 'Network unavailable. Please check your connection.';
  static const String errorAuthFailed = 'Authentication failed. Please try again.';
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorInsufficientCoins = 'Insufficient coins for this purchase.';

  // Success Messages
  static const String successWorkoutSaved = 'Workout saved successfully!';
  static const String successPurchaseComplete = 'Purchase completed!';
  static const String successGoalAchieved = 'Weekly goal achieved! 🎉';
}
