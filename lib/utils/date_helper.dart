import 'package:intl/intl.dart';

class DateHelper {
  // Format date as 'YYYY-MM-DD' for workoutDateKey
  static String toDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Parse date key back to DateTime
  static DateTime fromDateKey(String dateKey) {
    return DateFormat('yyyy-MM-dd').parse(dateKey);
  }

  // Format date for display (e.g., "2026年1月7日")
  static String formatDisplayDate(DateTime date) {
    return DateFormat('yyyy年M月d日', 'ja').format(date);
  }

  // Format date with day of week (e.g., "1月7日(火)")
  static String formatDateWithDay(DateTime date) {
    return DateFormat('M月d日(E)', 'ja').format(date);
  }

  // Get start of week based on preference ('mon' or 'sun')
  static DateTime getWeekStart(DateTime date, String weekStartsOn) {
    int daysToSubtract;
    if (weekStartsOn == 'sun') {
      daysToSubtract = date.weekday % 7; // Sunday = 0
    } else {
      // Default to Monday
      daysToSubtract = date.weekday - 1; // Monday = 0
    }
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
  }

  // Get end of week
  static DateTime getWeekEnd(DateTime weekStart) {
    return weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  // Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get today's date key
  static String getTodayKey() {
    return toDateKey(DateTime.now());
  }

  // Check if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  // Get list of dates in current week
  static List<String> getCurrentWeekDateKeys(String weekStartsOn) {
    final now = DateTime.now();
    final weekStart = getWeekStart(now, weekStartsOn);
    final List<String> dateKeys = [];
    
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      dateKeys.add(toDateKey(date));
    }
    
    return dateKeys;
  }
}
