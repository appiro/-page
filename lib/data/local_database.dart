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
  TextColumn get userId => text()(); // To support multiple users/guest separation if needed
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
  TextColumn get workoutId => text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  TextColumn get memo => text()();
  IntColumn get orderIndex => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutSetEntity')
class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(WorkoutItems, #id, onDelete: KeyAction.cascade)();
  RealColumn get weight => real()();
  IntColumn get reps => integer()();
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
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalEconomyStateEntity')
class LocalEconomyState extends Table {
  TextColumn get id => text()(); // Singleton ID 'state'
  IntColumn get totalCoins => integer().withDefault(const Constant(0))();
  
  @override
  Set<Column> get primaryKey => {id};
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
  DateTimeColumn get timestamp => dateTime()(); // Precise time for same-day multiple records
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
  DateTimeColumn get weeklyGoalUpdatedAt => dateTime().nullable()(); // Added
  BoolColumn get vibrationOn => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsOn => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {uid};
}

// ==================== Database ====================

@DriftDatabase(tables: [
  Workouts, 
  WorkoutItems, 
  WorkoutSets, 
  LocalBodyParts, 
  LocalExercises,
  LocalEconomyState,
  LocalPurchasedItems,
  LocalUnlockedTitles,
  LocalBodyCompositionEntries,
  LocalUserProfiles,
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());
  LocalDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 5;

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
          'ALTER TABLE local_body_composition_entries ADD COLUMN timestamp INTEGER NOT NULL DEFAULT 0'
        );
        await customStatement(
          'ALTER TABLE local_body_composition_entries ADD COLUMN note TEXT'
        );
        await customStatement(
          "ALTER TABLE local_body_composition_entries ADD COLUMN source TEXT NOT NULL DEFAULT 'manual'"
        );
      }
      if (from < 4) {
        await m.createTable(localUserProfiles);
      }
      if (from < 5) {
        await customStatement(
          'ALTER TABLE local_user_profiles ADD COLUMN weekly_goal_updated_at INTEGER'
        );
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
