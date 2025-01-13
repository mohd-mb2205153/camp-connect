

# CampConnect: Connecting Displaced Students to Educational Camps

CampConnect is a Flutter-based mobile application designed to bridge the gap between displaced students and educational opportunities. The app uses geolocation and real-time data to connect users with nearby educational camps, resources, and mentors, fostering access to structured learning and a supportive community.

---

## Installation and Setup

### Prerequisites
- Install Flutter SDK ([Flutter installation guide](https://flutter.dev/docs/get-started/install))
- Install Android Studio or Visual Studio Code with the Flutter extension
- Ensure you have a connected device or emulator to run the app

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/connected.git
   cd connected
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set up a Firebase project for backend support:
   - Create a Firebase project ([Firebase Console](https://console.firebase.google.com/))
   - Add your app's configuration file (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) to the respective directories (`android/app` and `ios/Runner`).
   
4. Update the `pubspec.yaml` file with any required third-party plugins (already included in the repository).

5. Run the app:
   ```bash
   flutter run
   ```

---

## Running/Testing the Project

1. **Run on Emulator or Device:**
   - Connect a physical device via USB or launch an emulator.
   - Execute:
     ```bash
     flutter run
     ```

2. **Testing:**
   - Run automated tests:
     ```bash
     flutter test
     ```
   - For widget tests:
     ```bash
     flutter test test/widget_test.dart
     ```

---

## Credits
- **Development Team:**
  - Marcus Monteiro 
  - Fahrel Hidayat
  - Mohd Muhtasim Bashar
  - Mohd Shahriar Alam

---

## License
This project is licensed under the GPL License. See the [LICENSE](LICENSE) file for details.

