

# CampConnect: Connecting Displaced Students to Educational Camps

CampConnect is a Flutter-based mobile application designed to bridge the gap between displaced students and educational opportunities. The app uses geolocation and real-time data to connect users with nearby educational camps, resources, and mentors, fostering access to structured learning and a supportive community.

Project Video:

[https://youtu.be/NW1u85gMUBk?si=q1L-S18u7zzF3_0v](https://youtu.be/NW1u85gMUBk?si=q1L-S18u7zzF3_0v)
---

## Installation and Setup

### Prerequisites
- Install Flutter SDK ([Flutter installation guide](https://flutter.dev/docs/get-started/install))
- Install Android Studio or Visual Studio Code with the Flutter extension
- Ensure you have a connected device or emulator to run the app

### Steps
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set up a Firebase project for backend support (Optional, only execute this step if you want to view the backend):
   - Create a Firebase project ([Firebase Console](https://console.firebase.google.com/))
   - Add your app's configuration file (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) to the respective directories (`android/app` and `ios/Runner`).
   
4. Update the `pubspec.yaml` file with any required third-party plugins (already included in the repository).

5. Run the app:
   ```bash
   flutter run
   ```

---

## Running the Project

- **Run on Emulator or Device:**
   - Connect a physical device via USB or launch an emulator.
   - Execute:
     ```bash
     flutter run
     ```
- **Sign-in on the App:**
   - Log in as Student using the given credential:
     - Username: peter@gmail.com
     - Password: peter123
   - Log in as Teacher using the given credential:
     - Username: ali@gmail.com
     - Password: ali123

## Future Plans

We have exciting plans to enhance the functionality of our app in the future:

- **Offline Functionality**: Allow users to access the app and its features without an internet connection.
- **Advanced Filtering**: Implement filters to allow users to search and sort camps based on specific attributes for a more personalized experience.

---

## Credits
- **Development Team:**
  - Marcus Monteiro - marcuswein0210@gmail.com
  - Fahrel Hidayat - fahrelazki@gmail.com
  - Mohd Muhtasim Bashar - muhtasim2k2@gmail.com
  - Mohammad Mansib - mohdmansib@gmail.com

---

## License
This project is licensed under the GPL License. See the [LICENSE](LICENSE) file for details.

