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
import 'screens/home_screen.dart';
import 'utils/constants.dart';
import 'data/local_database.dart';
import 'repositories/fit_repository.dart';
import 'repositories/local_repository.dart';
import 'repositories/firestore_repository.dart';

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
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppConstants.primaryColor,
                ),
                useMaterial3: true,
                cardTheme: const CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppConstants.cardBorderRadius)),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, AppConstants.minTapTargetSize),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    ),
                  ),
                ),
              ),
              home: const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
