import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

import '../data/local_database.dart';
import '../repositories/local_repository.dart';
import '../repositories/firestore_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final LocalDatabase? _localDatabase;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authService, {LocalDatabase? localDatabase}) : _localDatabase = localDatabase {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithGoogle();
      
      // Data Migration for new users (Inherit from Guest)
      if (userCredential != null && 
          (userCredential.additionalUserInfo?.isNewUser ?? false) && 
          _localDatabase != null) {
        await _migrateData(userCredential.user!.uid);
      }

      _isLoading = false;
      notifyListeners();
      return userCredential != null;
    } catch (e) {
      print('AuthProvider Sign In Error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _migrateData(String newUid) async {
    try {
      final localRepo = LocalRepository(_localDatabase!);
      final firestoreRepo = FirestoreRepository();
      
      // 1. Migrate Workouts
      // 'guest' uid is typically used for local, or we just fetch everything in DB
      final workouts = await localRepo.getAllWorkouts('guest');
      for (final workout in workouts) {
        // Create new workout in Firestore (IDs will be regenerated to avoid conflicts)
        await firestoreRepo.createWorkout(newUid, workout);
      }

      // 2. Migrate Body Composition
      final bodyComps = await localRepo.getAllBodyCompositionEntries('guest');
      for (final entry in bodyComps) {
        await firestoreRepo.saveBodyCompositionEntry(newUid, entry);
      }

      // 3. Migrate Economy (Coins, Unlocks)
      final economy = await localRepo.getEconomyState('guest');
      if (economy.totalCoins > 0 || economy.purchasedItemIds.isNotEmpty) {
         await firestoreRepo.updateEconomyState(newUid, economy);
      }

      // 4. Migrate User Settings
      final localProfile = await localRepo.getUserProfile('guest');
        if (localProfile != null) {
          await firestoreRepo.updateUserProfile(newUid, {
            'weeklyGoal': localProfile.weeklyGoal,
            'weeklyGoalAnchor': localProfile.weeklyGoalAnchor,
            'lastRewardedCycleIndex': localProfile.lastRewardedCycleIndex,
            'weeklyGoalUpdatedAt': localProfile.weeklyGoalUpdatedAt,
            'vibrationOn': localProfile.vibrationOn,
            'notificationsOn': localProfile.notificationsOn,
            // Don't overwrite displayName/email from Google
          });
        }
      
    } catch (e) {
      print("Migration Error: $e");
      // Don't fail the login, just log error
      throw e; // Re-throw to handle in caller if needed
    }
  }

  // Manually trigger migration (e.g. if initial sync failed)
  Future<bool> syncLocalDataToCloud() async {
    if (_user == null || _localDatabase == null) return false;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _migrateData(_user!.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Sync Error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
