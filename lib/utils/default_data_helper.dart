import '../repositories/fit_repository.dart';
import '../models/exercise_measure_type.dart';

class DefaultDataHelper {
  static const List<String> defaultExerciseNames = [
    'ベンチプレス',
    'ダンベルプレス',
    'ダンベルフライ',
    'プッシュアップ',
    'デッドリフト',
    'ラットプルダウン',
    'ベントオーバーロウ',
    'シーテッドロウ',
    'チンニング',
    'ショルダープレス',
    'サイドレイズ',
    'フロントレイズ',
    'リアレイズ',
    'バーベルカール',
    'ダンベルカール',
    'ハンマーカール',
    'トライセプスエクステンション',
    'ディップス',
    'スクワット',
    'レッグプレス',
    'レッグエクステンション',
    'レッグカール',
    'カーフレイズ',
    'ランジ',
    'プランク',
    'クランチ',
    'レッグレイズ',
    'サイドプランク',
  ];

  static Future<void> createDefaultData(
    String uid,
    FitRepository repository,
  ) async {
    try {
      // Check if data already exists
      final bodyParts = await repository.getBodyParts(uid);
      if (bodyParts.isNotEmpty) {
        return; // Data already exists
      }

      // Create default body parts
      final bodyPartMap = <String, String>{};

      final chest = await repository.createBodyPart(uid, '胸', 0);
      final chestId = chest.id;

      final back = await repository.createBodyPart(uid, '背中', 1);
      final backId = back.id;

      final shoulder = await repository.createBodyPart(uid, '肩', 2);
      final shoulderId = shoulder.id;

      final arms = await repository.createBodyPart(uid, '腕', 3);
      final armsId = arms.id;

      final legs = await repository.createBodyPart(uid, '脚', 4);
      final legsId = legs.id;

      final core = await repository.createBodyPart(uid, '体幹', 5);
      final coreId = core.id;

      final other = await repository.createBodyPart(uid, 'その他', 6);
      final otherId = other.id;

      // Create default exercises for each body part

      // 胸
      await repository.createExercise(uid, 'ベンチプレス', chestId, 0);
      await repository.createExercise(uid, 'ダンベルプレス', chestId, 1);
      await repository.createExercise(uid, 'ダンベルフライ', chestId, 2);
      await repository.createExercise(uid, 'プッシュアップ', chestId, 3);

      // 背中
      await repository.createExercise(uid, 'デッドリフト', backId, 0);
      await repository.createExercise(uid, 'ラットプルダウン', backId, 1);
      await repository.createExercise(uid, 'ベントオーバーロウ', backId, 2);
      await repository.createExercise(uid, 'シーテッドロウ', backId, 3);
      await repository.createExercise(uid, 'チンニング', backId, 4);

      // 肩
      await repository.createExercise(uid, 'ショルダープレス', shoulderId, 0);
      await repository.createExercise(uid, 'サイドレイズ', shoulderId, 1);
      await repository.createExercise(uid, 'フロントレイズ', shoulderId, 2);
      await repository.createExercise(uid, 'リアレイズ', shoulderId, 3);

      // 腕
      await repository.createExercise(uid, 'バーベルカール', armsId, 0);
      await repository.createExercise(uid, 'ダンベルカール', armsId, 1);
      await repository.createExercise(uid, 'ハンマーカール', armsId, 2);
      await repository.createExercise(uid, 'トライセプスエクステンション', armsId, 3);
      await repository.createExercise(uid, 'ディップス', armsId, 4);

      // 脚
      await repository.createExercise(uid, 'スクワット', legsId, 0);
      await repository.createExercise(uid, 'レッグプレス', legsId, 1);
      await repository.createExercise(uid, 'レッグエクステンション', legsId, 2);
      await repository.createExercise(uid, 'レッグカール', legsId, 3);
      await repository.createExercise(uid, 'カーフレイズ', legsId, 4);
      await repository.createExercise(uid, 'ランジ', legsId, 5);

      // 体幹
      await repository.createExercise(
        uid,
        'プランク',
        coreId,
        0,
        measureType: ExerciseMeasureType.time,
      );
      await repository.createExercise(
        uid,
        'クランチ',
        coreId,
        1,
        measureType: ExerciseMeasureType.time,
      );
      await repository.createExercise(
        uid,
        'レッグレイズ',
        coreId,
        2,
        measureType: ExerciseMeasureType.time,
      );
      await repository.createExercise(
        uid,
        'サイドプランク',
        coreId,
        3,
        measureType: ExerciseMeasureType.time,
      );
    } catch (e) {
      // Ignore errors
      print('Failed to create default data: $e');
    }
  }

  static Future<void> migrateMeasureTypes(
    String uid,
    FitRepository repository,
  ) async {
    try {
      final exercises = await repository.getExercisesStream(uid).first;
      final timeBasedNames = ['プランク', 'サイドプランク', 'クランチ', 'レッグレイズ'];

      for (var exercise in exercises) {
        if (timeBasedNames.contains(exercise.name) &&
            exercise.measureType == ExerciseMeasureType.weightReps) {
          final updated = exercise.copyWith(
            measureType: ExerciseMeasureType.time,
          );
          await repository.updateExercise(uid, updated);
          print('Migrated ${exercise.name} to time-based');
        }
      }
    } catch (e) {
      print('Migration failed: $e');
    }
  }

  static Future<void> ensureOtherBodyPartExists(
    String uid,
    FitRepository repository,
  ) async {
    try {
      final bodyParts = await repository.getBodyParts(uid);
      final exists = bodyParts.any((bp) => bp.name == 'その他');

      if (!exists) {
        // Find max order
        final maxOrder = bodyParts.isEmpty
            ? 0
            : bodyParts.map((e) => e.order).reduce((a, b) => a > b ? a : b);

        await repository.createBodyPart(uid, 'その他', maxOrder + 1);
        print("Created 'Others' body part");
      }
    } catch (e) {
      print('Failed to ensure Other body part: $e');
    }
  }
}
