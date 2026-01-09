# ⚠️ IMPORTANT: Firebase Configuration Required

This project currently uses **DUMMY Firebase configuration files** for development purposes only.

## Current Status

The following files are dummy placeholders:
- `android/app/google-services.json` - ⚠️ DUMMY FILE
- `ios/Runner/GoogleService-Info.plist` - ⚠️ DUMMY FILE

## What This Means

✅ **You CAN:**
- Build and run the app
- Test the UI and navigation
- Develop features locally

❌ **You CANNOT:**
- Sign in with Google (authentication will fail)
- Save data to Firestore (database operations will fail)
- Use any Firebase features

## To Enable Full Functionality

Replace the dummy files with real Firebase configuration:

### 1. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Follow the setup wizard

### 2. Add Android App
1. In Firebase Console, click "Add app" → Android
2. Package name: `com.example.fit_app`
3. Download `google-services.json`
4. Replace `android/app/google-services.json` with the downloaded file

### 3. Add iOS App
1. In Firebase Console, click "Add app" → iOS
2. Bundle ID: `com.example.fitApp`
3. Download `GoogleService-Info.plist`
4. Replace `ios/Runner/GoogleService-Info.plist` with the downloaded file

### 4. Enable Firebase Services

#### Authentication
1. Go to Firebase Console → Authentication
2. Enable "Google" sign-in method

#### Firestore
1. Go to Firebase Console → Firestore Database
2. Create database in production mode
3. Update security rules (see main README.md)

## Development Without Firebase

If you want to develop without Firebase temporarily:
1. Comment out Firebase initialization in `lib/main.dart`
2. Use mock data providers
3. Test UI components independently

---

For complete setup instructions, see the main [README.md](README.md).
