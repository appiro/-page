# Fit App

A lightweight, fast Flutter workout tracking app with Google authentication, cloud sync, and motivational features.

## Features

- 📝 Quick workout logging with "Last Record" display
- 🔥 Weekly goal tracking with achievements
- 💰 Economy system with coins and purchasable items
- 🏆 Title system for motivation
- 📊 Stats and 1RM calculations
- ⏱️ Interval timer with notifications
- 📅 Calendar view for workout history
- ☁️ Cloud sync with Firebase
- 📴 Offline support

## Firebase Setup

Before running the app, you need to set up Firebase:

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the setup wizard
3. Enable Google Analytics (optional)

### 2. Add iOS App

1. In Firebase Console, click "Add app" → iOS
2. Register your app with bundle ID: `com.example.fitApp` (or your custom bundle ID)
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

### 3. Add Android App

1. In Firebase Console, click "Add app" → Android
2. Register your app with package name: `com.example.fit_app` (or your custom package name)
3. Download `google-services.json`
4. Place it in `android/app/` directory

### 4. Enable Firebase Services

#### Authentication
1. Go to Firebase Console → Authentication
2. Click "Get started"
3. Enable "Google" sign-in method
4. Add your support email

#### Firestore Database
1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **production mode** (we'll add security rules)
4. Choose a location close to your users

#### Security Rules
1. In Firestore, go to "Rules" tab
2. Replace with the following rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User data - only accessible by the user
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Subcollections inherit the same rule
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

3. Click "Publish"

#### Indexes
Create composite indexes in Firestore:

1. Collection: `users/{uid}/workouts`
   - Fields: `workoutDateKey` (Ascending), `createdAt` (Descending)

2. Collection: `users/{uid}/exercises`
   - Fields: `bodyPartId` (Ascending), `order` (Ascending)

(Firestore will prompt you to create these when you first run queries that need them)

### 5. iOS Configuration (Additional Steps)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Add `GoogleService-Info.plist` to the project if not already added
3. Update `ios/Runner/Info.plist` with URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### 6. Android Configuration (Additional Steps)

The `google-services.json` file should be sufficient, but ensure:

1. `android/build.gradle` has Google services classpath (already added in dependencies)
2. `android/app/build.gradle` applies the plugin (already configured)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- iOS: Xcode 14+ and CocoaPods
- Android: Android Studio with SDK 21+

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd fit_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up Firebase (see above)

4. Run the app
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── services/                 # Business logic services
├── providers/                # State management (Provider)
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
└── utils/                    # Utilities and constants
```

## Architecture

- **State Management**: Provider
- **Backend**: Firebase (Auth, Firestore)
- **Local Storage**: Firestore offline persistence
- **Notifications**: flutter_local_notifications

## Key Decisions

### Economy System
- Coins awarded based on total volume: Σ(weight × reps)
- Bodyweight exercises (weight=0) award 0 coins initially
- Coins granted once per workout (no recalculation on edit)

### Weekly Goal
- Counts workouts in current week
- Week starts on Monday (configurable in settings)
- Bonus coins awarded on goal achievement

## Development

### Running Tests
```bash
flutter test
```

### Building for Production

#### iOS
```bash
flutter build ios --release
```

#### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

## Troubleshooting

### Firebase Connection Issues
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct locations
- Check that package name/bundle ID matches Firebase configuration
- Verify internet connection

### Google Sign-In Not Working
- iOS: Ensure URL scheme is added to Info.plist
- Android: Ensure SHA-1 fingerprint is added to Firebase project
- Check that Google Sign-In is enabled in Firebase Console

### Firestore Permission Denied
- Verify security rules are published
- Ensure user is authenticated before accessing Firestore
- Check that user UID matches document path

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please open an issue on GitHub.
