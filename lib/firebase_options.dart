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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBidxFrfXazewtkAu27GyLLLcZJxUy3Jqs',
    appId: '1:1077354284989:web:c6b5de8045fd74917bb4d4',
    messagingSenderId: '1077354284989',
    projectId: 'keep-clone-d05ec',
    authDomain: 'keep-clone-d05ec.firebaseapp.com',
    storageBucket: 'keep-clone-d05ec.appspot.com',
    measurementId: 'G-3HD0PB87LK',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6p-XGSw4zNORcEI5VDTzwwpvz66bJH1w',
    appId: '1:1077354284989:ios:fd001ed8fe7debfe7bb4d4',
    messagingSenderId: '1077354284989',
    projectId: 'keep-clone-d05ec',
    storageBucket: 'keep-clone-d05ec.appspot.com',
    iosBundleId: 'com.example.googleKeepClone',
  );
}
