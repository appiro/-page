import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Include the generated file (will be created by build_runner)
part 'local_database.g.dart';

// ==================== Tables ====================

@DataClassName('WorkoutEntity')
class Workouts extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text()(); // To support multiple users/guest separation if needed
  TextColumn get title => text()();
  TextColumn get note => text()();
  TextColumn get workoutDateKey => text()(); // YYYY-MM-DD
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get coinReward => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutItemEntity')
class WorkoutItems extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId =>
      text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  TextColumn get memo => text()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutSetEntity')
class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get itemId =>
      text().references(WorkoutItems, #id, onDelete: KeyAction.cascade)();
  RealColumn get weight => real().nullable()(); // nullable
  IntColumn get reps => integer().nullable()(); // nullable
  IntColumn get durationSec => integer().nullable()(); // 追加
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  BoolColumn get isAssisted => boolean().withDefault(const Constant(false))();
  IntColumn get index => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalBodyPartEntity')
class LocalBodyParts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalExerciseEntity')
class LocalExercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get bodyPartId => text()();
  IntColumn get orderIndex => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get measureType =>
      text().withDefault(const Constant('weightReps'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalEconomyStateEntity')
class LocalEconomyState extends Table {
  TextColumn get id => text()(); // Singleton ID 'state'
  IntColumn get totalCoins => integer().withDefault(const Constant(0))();
  IntColumn get fishingTickets => integer().withDefault(const Constant(0))();
  TextColumn get equippedTitleId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Achievement counts (key-value pairs)
@DataClassName('LocalAchievementEntity')
class LocalAchievements extends Table {
  TextColumn get achievementKey => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {achievementKey};
}

// Fishing inventory
@DataClassName('LocalInventoryEntity')
class LocalInventory extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  IntColumn get remainingUses => integer()();
  DateTimeColumn get acquiredAt => dateTime()();
  BoolColumn get isEquipped => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Fish collection (caught fish counts)
@DataClassName('LocalFishCollectionEntity')
class LocalFishCollection extends Table {
  TextColumn get fishId => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {fishId};
}

@DataClassName('LocalPurchasedItemEntity')
class LocalPurchasedItems extends Table {
  TextColumn get itemId => text()();
  DateTimeColumn get purchasedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DataClassName('LocalUnlockedTitleEntity')
class LocalUnlockedTitles extends Table {
  TextColumn get titleId => text()();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {titleId};
}

@DataClassName('LocalBodyCompositionEntryEntity')
class LocalBodyCompositionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get dateKey => text()(); // YYYY-MM-DD
  DateTimeColumn get timestamp =>
      dateTime()(); // Precise time for same-day multiple records
  RealColumn get weight => real()();
  RealColumn get bodyFatPercentage => real().nullable()();
  RealColumn get muscleMass => real().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalUserProfileEntity')
class LocalUserProfiles extends Table {
  TextColumn get uid => text()();
  TextColumn get email => text().nullable()();
  TextColumn get displayName => text().nullable()();
  IntColumn get weeklyGoal => integer().withDefault(const Constant(3))();
  TextColumn get weekStartsOn => text().withDefault(const Constant('mon'))();
  DateTimeColumn get weeklyGoalUpdatedAt => dateTime().nullable()();
  // New columns for cycle-based goals
  DateTimeColumn get weeklyGoalAnchor => dateTime().nullable()();
  IntColumn get lastRewardedCycleIndex =>
      integer().withDefault(const Constant(-1))();

  BoolColumn get vibrationOn => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsOn =>
      boolean().withDefault(const Constant(true))();
  TextColumn get seenTutorials => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {uid};
}

// ==================== Database ====================

@DriftDatabase(
  tables: [
    Workouts,
    WorkoutItems,
    WorkoutSets,
    LocalBodyParts,
    LocalExercises,
    LocalEconomyState,
    LocalAchievements,
    LocalInventory,
    LocalFishCollection,
    LocalPurchasedItems,
    LocalUnlockedTitles,
    LocalBodyCompositionEntries,
    LocalUserProfiles,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
  LocalDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(localBodyCompositionEntries);
      }
      if (from < 3) {
        // Add new columns to existing body composition table using raw SQL
        await customStatement(
          'ALTER TABLE local_body_composition_entries ADD COLUMN timestamp INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'ALTER TABLE local_body_composition_entries ADD COLUMN note TEXT',
        );
        await customStatement(
          "ALTER TABLE local_body_composition_entries ADD COLUMN source TEXT NOT NULL DEFAULT 'manual'",
        );
      }
      if (from < 4) {
        await m.createTable(localUserProfiles);
      }
      if (from < 5) {
        await customStatement(
          'ALTER TABLE local_user_profiles ADD COLUMN weekly_goal_updated_at INTEGER',
        );
      }
      if (from < 6) {
        await m.addColumn(
          localUserProfiles,
          localUserProfiles.weeklyGoalAnchor as GeneratedColumn<Object>,
        );
        await m.addColumn(
          localUserProfiles,
          localUserProfiles.lastRewardedCycleIndex as GeneratedColumn<Object>,
        );
      }
      if (from < 7) {
        // Add new economy-related columns and tables
        await customStatement(
          'ALTER TABLE local_economy_state ADD COLUMN fishing_tickets INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'ALTER TABLE local_economy_state ADD COLUMN equipped_title_id TEXT',
        );

        // Create new tables
        await m.createTable(localAchievements);
        await m.createTable(localInventory);
        await m.createTable(localFishCollection);
      }
      if (from < 8) {
        await m.addColumn(
          localUserProfiles,
          localUserProfiles.seenTutorials as GeneratedColumn<Object>,
        );
      }
      if (from < 9) {
        // 1. Add measureType to localExercises
        await m.addColumn(localExercises, localExercises.measureType);

        // 2. Recreate workoutSets table to support nullable weight/reps and add durationSec
        // Since we are changing column constraints (NOT NULL -> NULL), recreating is safer/required in SQLite

        // Rename old table
        await customStatement(
          'ALTER TABLE workout_sets RENAME TO workout_sets_old',
        );

        // Create new table (this uses the current class definition which has nullable weight/reps and durationSec)
        await m.createTable(workoutSets);

        // Copy data
        // Note: "index" is a reserved keyword in SQL, so we quote it.
        // We don't copy durationSec as it doesn't exist in old table (it will be null in new table)
        await customStatement('''
          INSERT INTO workout_sets (id, item_id, weight, reps, is_warmup, is_assisted, "index")
          SELECT id, item_id, weight, reps, is_warmup, is_assisted, "index"
          FROM workout_sets_old
        ''');

        // Drop old table
        await customStatement('DROP TABLE workout_sets_old');
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fit_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
