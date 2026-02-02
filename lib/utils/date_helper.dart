import 'package:flutter/material.dart';
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
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysToSubtract));
  }

  // Get end of week
  static DateTime getWeekEnd(DateTime weekStart) {
    return weekStart.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
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

  // --- Cycle-based Goal Logic ---

  // Calculate cycle index for a given date relative to anchor
  static int getCycleIndex(DateTime anchor, DateTime target) {
    // Normalize to UTC milliseconds to avoid timezone/DST shifts affecting calculation
    final anchorMs = anchor.toUtc().millisecondsSinceEpoch;
    final targetMs = target.toUtc().millisecondsSinceEpoch;
    final diffMs = targetMs - anchorMs;

    // 1 week = 7 * 24 * 60 * 60 * 1000 ms
    const weekMs = 7 * 24 * 3600 * 1000;

    if (diffMs < 0) return -1; // Before anchor
    return (diffMs / weekMs).floor();
  }

  // Get start (inclusive) and end (exclusive) for a cycle
  static DateTimeRange getCycleRange(DateTime anchor, int cycleIndex) {
    final start = anchor.add(Duration(days: cycleIndex * 7));
    final end = start.add(const Duration(days: 7));
    return DateTimeRange(start: start, end: end);
  }

  // Get list of date keys covering the cycle range (for querying)
  // Range is [start, end) - inclusive of start, exclusive of end
  static List<String> getDateKeysForCycle(DateTime anchor, int cycleIndex) {
    final range = getCycleRange(anchor, cycleIndex);
    final keys = <String>{}; // Set to avoid duplicates

    // Debug logging
    print('📅 [getDateKeysForCycle] anchor: $anchor, cycleIndex: $cycleIndex');
    print('   range.start: ${range.start}');
    print('   range.end: ${range.end}');

    // Iterate from start day to the day before end
    // Since end is exclusive, we stop when current reaches end's date
    var current = range.start;

    // Loop while current is before end (not including end's date)
    while (current.isBefore(range.end)) {
      keys.add(toDateKey(current));
      current = current.add(const Duration(days: 1));
    }

    print('   Generated keys: $keys');

    return keys.toList();
  }
}
