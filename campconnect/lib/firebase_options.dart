// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJX-NbCXR_q_5OVQP6qMngNtI5mS6vHJI',
    appId: '1:122981442656:web:164cd0d7d44e837b470f05',
    messagingSenderId: '122981442656',
    projectId: 'camp-connect-2c4d7',
    authDomain: 'camp-connect-2c4d7.firebaseapp.com',
    storageBucket: 'camp-connect-2c4d7.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZYj5lUjxNfsWMeFWL9-CwfIkonL2kZTg',
    appId: '1:122981442656:android:772aee161df2c625470f05',
    messagingSenderId: '122981442656',
    projectId: 'camp-connect-2c4d7',
    storageBucket: 'camp-connect-2c4d7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeYxv4_INxOGLB0Km_YUvNDwhvFGD6kw0',
    appId: '1:122981442656:ios:cddaa1df1a727e73470f05',
    messagingSenderId: '122981442656',
    projectId: 'camp-connect-2c4d7',
    storageBucket: 'camp-connect-2c4d7.firebasestorage.app',
    iosBundleId: 'com.example.campconnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeYxv4_INxOGLB0Km_YUvNDwhvFGD6kw0',
    appId: '1:122981442656:ios:cddaa1df1a727e73470f05',
    messagingSenderId: '122981442656',
    projectId: 'camp-connect-2c4d7',
    storageBucket: 'camp-connect-2c4d7.firebasestorage.app',
    iosBundleId: 'com.example.campconnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDJX-NbCXR_q_5OVQP6qMngNtI5mS6vHJI',
    appId: '1:122981442656:web:53513c5c85b7735f470f05',
    messagingSenderId: '122981442656',
    projectId: 'camp-connect-2c4d7',
    authDomain: 'camp-connect-2c4d7.firebaseapp.com',
    storageBucket: 'camp-connect-2c4d7.firebasestorage.app',
  );
}
