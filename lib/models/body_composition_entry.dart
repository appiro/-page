import 'package:cloud_firestore/cloud_firestore.dart';

class BodyCompositionEntry {
  final String id;
  final String dateKey; // YYYY-MM-DD (for grouping by day)
  final DateTime timestamp; // Precise time for same-day multiple records
  final double weight; // kg
  final double? bodyFatPercentage; // %
  final double? muscleMass; // kg
  final String? note; // User memo
  final String source; // 'manual', 'scale', 'inbody', etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  BodyCompositionEntry({
    required this.id,
    required this.dateKey,
    required this.timestamp,
    required this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.note,
    this.source = 'manual',
    required this.createdAt,
    required this.updatedAt,
  });

  // Derived values (calculated, not stored)
  double? get bodyFatMass {
    if (bodyFatPercentage == null) return null;
    return weight * bodyFatPercentage! / 100;
  }

  double? get leanBodyMass {
    if (bodyFatPercentage == null) return null;
    return weight - bodyFatMass!;
  }

  factory BodyCompositionEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BodyCompositionEntry(
      id: doc.id,
      dateKey: data['dateKey'] ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : (data['createdAt'] as Timestamp).toDate(),
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      bodyFatPercentage: (data['bodyFatPercentage'] as num?)?.toDouble(),
      muscleMass: (data['muscleMass'] as num?)?.toDouble(),
      note: data['note'] as String?,
      source: data['source'] as String? ?? 'manual',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'dateKey': dateKey,
      'timestamp': Timestamp.fromDate(timestamp),
      'weight': weight,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'note': note,
      'source': source,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  BodyCompositionEntry copyWith({
    String? id,
    String? dateKey,
    DateTime? timestamp,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    String? note,
    String? source,
    DateTime? updatedAt,
  }) {
    return BodyCompositionEntry(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      timestamp: timestamp ?? this.timestamp,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
      note: note ?? this.note,
      source: source ?? this.source,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Validation
  static String? validateWeight(double? weight) {
    if (weight == null || weight <= 0) {
      return '体重を入力してください';
    }
    if (weight > 300) {
      return '体重は300kg以下で入力してください';
    }
    return null;
  }

  static String? validateBodyFat(double? bodyFat) {
    if (bodyFat == null) return null; // Optional
    if (bodyFat < 0 || bodyFat > 80) {
      return '体脂肪率は0〜80%の範囲で入力してください';
    }
    return null;
  }

  static String? validateMuscleMass(double? muscleMass) {
    if (muscleMass == null) return null; // Optional
    if (muscleMass <= 0 || muscleMass > 150) {
      return '筋肉量は0〜150kgの範囲で入力してください';
    }
    return null;
  }
}
