import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createInitialUserData(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e, stack) {
      print('Google Sign In Error: $e');
      print(stack);
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  // Create initial user data in Firestore
  Future<void> _createInitialUserData(User user) async {
    final now = DateTime.now();
    
    try {
      // Create user profile
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set({
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        'unit': AppConstants.defaultUnit,
        'weeklyGoal': AppConstants.defaultWeeklyGoal,
        'weekStartsOn': AppConstants.defaultWeekStartsOn,
        'vibrationOn': true,
        'notificationsOn': true,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // Create initial economy state
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .collection('economy')
          .doc('state')
          .set({
        'totalCoins': 0,
        'equippedTitleId': null,
        'unlockedTitleIds': [],
        'purchasedItemIds': [],
        'achievementCounts': {},
      });

      // Create default body parts
      await _createDefaultBodyParts(user.uid);
    } catch (e) {
      throw Exception('Failed to create user data: ${e.toString()}');
    }
  }

  // Create default body parts for new users
  Future<void> _createDefaultBodyParts(String uid) async {
    final bodyParts = [
      {'name': 'Chest', 'order': 0},
      {'name': 'Back', 'order': 1},
      {'name': 'Legs', 'order': 2},
      {'name': 'Shoulders', 'order': 3},
      {'name': 'Arms', 'order': 4},
      {'name': 'Core', 'order': 5},
    ];

    final batch = _firestore.batch();
    final now = Timestamp.fromDate(DateTime.now());

    for (var bodyPart in bodyParts) {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection(AppConstants.bodyPartsSubcollection)
          .doc();

      batch.set(docRef, {
        ...bodyPart,
        'createdAt': now,
        'isArchived': false,
      });
    }

    await batch.commit();
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'network-request-failed':
        return AppConstants.errorNetworkUnavailable;
      default:
        return AppConstants.errorAuthFailed;
    }
  }
}
