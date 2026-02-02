import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'services/auth_service.dart';
import 'services/economy_service.dart';
import 'services/notification_service.dart';
import 'services/stats_service.dart';
import 'providers/auth_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/master_provider.dart';

import 'providers/economy_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/favorite_exercise_provider.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';
import 'data/local_database.dart';
import 'repositories/fit_repository.dart';
import 'repositories/local_repository.dart';
import 'repositories/firestore_repository.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting for Japanese
  await initializeDateFormatting('ja');
  
  // Initialize Firebase (but allow app to work without it)
  try {
    await Firebase.initializeApp();
    
    // Enable Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Continue without Firebase - app will work in guest mode
  }
  
  // Initialize notification service
  await NotificationService().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core Logic
        Provider<LocalDatabase>(
          create: (_) => LocalDatabase(),
          dispose: (_, db) => db.close(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<NotificationService>(
          create: (_) => NotificationService(),
        ),
        
        // Auth Provider
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
            localDatabase: context.read<LocalDatabase>(),
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final uid = authProvider.user?.uid ?? 'guest';
          
          // Determine which repository to use based on UID
          final FitRepository repository = uid == 'guest'
              ? LocalRepository(context.read<LocalDatabase>())
              : FirestoreRepository();

          debugPrint('🚀 App initializing for UID: $uid with ${repository.runtimeType}');

          return MultiProvider(
            key: ValueKey(uid), // Rebuild providers when UID changes
            providers: [
              // Inject Repository
              Provider<FitRepository>.value(value: repository),

              // Services dependent on Repository
              Provider<EconomyService>(
                create: (_) => EconomyService(repository),
              ),
              Provider<StatsService>(
                create: (_) => StatsService(repository),
              ),

              // Providers
              ChangeNotifierProvider<WorkoutProvider>(
                create: (context) {
                  return WorkoutProvider(
                    repository: repository,
                    economyService: context.read<EconomyService>(),
                    uid: uid,
                  );
                },
              ),
              ChangeNotifierProvider<MasterProvider>(
                create: (context) {
                  return MasterProvider(
                    repository: repository,
                    uid: uid,
                  );
                },
              ),
              ChangeNotifierProvider<EconomyProvider>(
                create: (context) {
                  return EconomyProvider(
                    repository: repository,
                    economyService: context.read<EconomyService>(),
                    uid: uid,
                  );
                },
              ),
              ChangeNotifierProvider<StatsProvider>(
                create: (context) {
                  return StatsProvider(
                    repository: repository,
                    uid: uid,
                  );
                },
              ),
              ChangeNotifierProvider<FavoriteExerciseProvider>(
                create: (context) => FavoriteExerciseProvider(),
              ),
            ],
            child: MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ja'),
              ],
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                scaffoldBackgroundColor: AppConstants.backgroundColor,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppConstants.primaryColor,
                  brightness: Brightness.light,
                  primary: AppConstants.primaryColor, // Navy for primary actions
                  secondary: AppConstants.accentColor, // Cyan for accents
                  surface: AppConstants.surfaceColor, // White cards
                  onSurface: const Color(0xFF1E293B), // Slate 800 for text
                  background: AppConstants.backgroundColor,
                  onBackground: const Color(0xFF1E293B),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppConstants.backgroundColor,
                  foregroundColor: AppConstants.primaryColor,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                ),
                cardTheme: CardThemeData(
                  color: AppConstants.surfaceColor,
                  elevation: 0, // Flat design requested
                  margin: EdgeInsets.zero, // Handle margins manually for cleaner control or keep default? 
                  // Let's keep elevation 0 but add a subtle border for definition
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE2E8F0), width: 1), // Slate 200
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: AppConstants.accentColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: AppConstants.surfaceColor,
                  selectedItemColor: AppConstants.primaryColor,
                  unselectedItemColor: Color(0xFF94A3B8), // Slate 400
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                ),
                textTheme: const TextTheme(
                  headlineMedium: TextStyle(
                    color: AppConstants.primaryColor, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  titleLarge: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  titleMedium: TextStyle(
                    color: Color(0xFF334155), // Slate 700
                    fontWeight: FontWeight.w600,
                  ),
                  bodyLarge: TextStyle(color: Color(0xFF334155)),
                  bodyMedium: TextStyle(color: Color(0xFF475569)), // Slate 600
                ),
                iconTheme: const IconThemeData(
                  color: AppConstants.primaryColor,
                ),
              ),
              home: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}
