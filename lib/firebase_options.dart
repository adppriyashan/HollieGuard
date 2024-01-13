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
    apiKey: 'AIzaSyDr7q2CY9L86TK8iAedxj92fsmRrYfV4vc',
    appId: '1:164656934685:web:f295fac77fa5e31821fbf4',
    messagingSenderId: '164656934685',
    projectId: 'parkisense',
    authDomain: 'parkisense.firebaseapp.com',
    databaseURL: 'https://parkisense-default-rtdb.firebaseio.com',
    storageBucket: 'parkisense.appspot.com',
    measurementId: 'G-XTN14HMX5C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzT7-yBbjnNELnTBAPNeutHsevG6TwH24',
    appId: '1:164656934685:android:8d6e30a50b79240221fbf4',
    messagingSenderId: '164656934685',
    projectId: 'parkisense',
    databaseURL: 'https://parkisense-default-rtdb.firebaseio.com',
    storageBucket: 'parkisense.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDz9Zsco8xwLWYCluS2WNMmZlmE_cXRMbE',
    appId: '1:164656934685:ios:d13fb29826fe78b621fbf4',
    messagingSenderId: '164656934685',
    projectId: 'parkisense',
    databaseURL: 'https://parkisense-default-rtdb.firebaseio.com',
    storageBucket: 'parkisense.appspot.com',
    iosBundleId: 'com.aries.parkisenseMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDz9Zsco8xwLWYCluS2WNMmZlmE_cXRMbE',
    appId: '1:164656934685:ios:d54a9ace52367d2021fbf4',
    messagingSenderId: '164656934685',
    projectId: 'parkisense',
    databaseURL: 'https://parkisense-default-rtdb.firebaseio.com',
    storageBucket: 'parkisense.appspot.com',
    iosBundleId: 'com.aries.parkisenseMobile.RunnerTests',
  );
}