import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'ツリトレ';
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
  static const Color primaryColor = Color(
    0xFF0F172A,
  ); // Deep Navy for headers/actions
  static const Color accentColor = Color(
    0xFF06B6D4,
  ); // Soft Cyan for highlights
  static const Color backgroundColor = Color(
    0xFFF8FAFC,
  ); // Light Gray background
  static const Color surfaceColor = Colors.white; // White surfaces
  static const Color errorColor = Color(0xFFEF4444); // Less harsh red
  static const Color successColor = Color(0xFF10B981); // Less harsh green
  static const Color warningColor = Color(0xFFF59E0B);

  // Achievement Keys
  static const String achievementWeeklyGoal = 'weeklyGoalAchieved';
  static const String achievementTotalWorkouts = 'totalWorkouts';
  static const String achievementTotalCoins = 'totalCoinsEarned';
  static const String achievementMaxVolume = 'maxVolume';
  static const String achievementTotalVolume = 'totalVolume';
  static const String achievementTotalDuration = 'totalDuration';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String workoutsSubcollection = 'workouts';
  static const String bodyPartsSubcollection = 'bodyParts';
  static const String exercisesSubcollection = 'exercises';
  static const String economyDocument = 'economy';

  // Error Messages
  static const String errorNetworkUnavailable =
      'Network unavailable. Please check your connection.';
  static const String errorAuthFailed =
      'Authentication failed. Please try again.';
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorInsufficientCoins =
      'Insufficient coins for this purchase.';

  // Success Messages
  static const String successWorkoutSaved = 'Workout saved successfully!';
  static const String successPurchaseComplete = 'Purchase completed!';
  static const String successGoalAchieved = 'Weekly goal achieved! 🎉';
}
