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
    apiKey: 'AIzaSyBZ44TTorUVRSyUkFPFTeJFttzXdxsDyjk',
    appId: '1:463265488556:web:d751124ccafed33fa18909',
    messagingSenderId: '463265488556',
    projectId: 'fluttershopvista-f228e',
    authDomain: 'fluttershopvista-f228e.firebaseapp.com',
    storageBucket: 'fluttershopvista-f228e.appspot.com',
    measurementId: 'G-9YWJ6B26WT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQ8awY1w49MAqfjTnXHg0xoIQ-i4WCBPs',
    appId: '1:463265488556:android:8e84c42353fe8393a18909',
    messagingSenderId: '463265488556',
    projectId: 'fluttershopvista-f228e',
    storageBucket: 'fluttershopvista-f228e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtuHbkhFg11RTSAn3WuVvTEjjo95RigFI',
    appId: '1:463265488556:ios:e8c7e56f0bbd3a5ba18909',
    messagingSenderId: '463265488556',
    projectId: 'fluttershopvista-f228e',
    storageBucket: 'fluttershopvista-f228e.appspot.com',
    iosBundleId: 'com.example.finalProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtuHbkhFg11RTSAn3WuVvTEjjo95RigFI',
    appId: '1:463265488556:ios:41bed3ed222bf71da18909',
    messagingSenderId: '463265488556',
    projectId: 'fluttershopvista-f228e',
    storageBucket: 'fluttershopvista-f228e.appspot.com',
    iosBundleId: 'com.example.finalProject.RunnerTests',
  );
}
