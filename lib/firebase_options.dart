// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyD-idooqsGawL_gcwT6H_sTsdMlHUkHEPk',
    appId: '1:1073440006416:web:3ba39fa505f36dcebbc595',
    messagingSenderId: '1073440006416',
    projectId: 'espeee-6a087',
    authDomain: 'espeee-6a087.firebaseapp.com',
    databaseURL: 'https://espeee-6a087-default-rtdb.firebaseio.com',
    storageBucket: 'espeee-6a087.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7a4NNppiWeQSjtLUBfKC5vD_S3sFLVoM',
    appId: '1:1073440006416:android:92c363a104b167fabbc595',
    messagingSenderId: '1073440006416',
    projectId: 'espeee-6a087',
    databaseURL: 'https://espeee-6a087-default-rtdb.firebaseio.com',
    storageBucket: 'espeee-6a087.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAE2l7XswaVTmc1IRJbmhN4praDu6OSDV4',
    appId: '1:1073440006416:ios:64b6fe2b43bbb297bbc595',
    messagingSenderId: '1073440006416',
    projectId: 'espeee-6a087',
    databaseURL: 'https://espeee-6a087-default-rtdb.firebaseio.com',
    storageBucket: 'espeee-6a087.appspot.com',
    iosBundleId: 'com.example.espeee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAE2l7XswaVTmc1IRJbmhN4praDu6OSDV4',
    appId: '1:1073440006416:ios:d7387dab783e4059bbc595',
    messagingSenderId: '1073440006416',
    projectId: 'espeee-6a087',
    databaseURL: 'https://espeee-6a087-default-rtdb.firebaseio.com',
    storageBucket: 'espeee-6a087.appspot.com',
    iosBundleId: 'com.example.espeee.RunnerTests',
  );
}
