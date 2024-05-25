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
    apiKey: 'AIzaSyAnv8x3Rfb0zpwwQ93eBaPWnKkyocRAle8',
    appId: '1:106748475408:web:6a0975d10be5190e3e7295',
    messagingSenderId: '106748475408',
    projectId: 'tuasu-2',
    authDomain: 'tuasu-2.firebaseapp.com',
    storageBucket: 'tuasu-2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsmHs9lhgRfRmtCXdiOV_tb97Tj_Xf0n0',
    appId: '1:106748475408:android:aa9c54355bbeecca3e7295',
    messagingSenderId: '106748475408',
    projectId: 'tuasu-2',
    storageBucket: 'tuasu-2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIDBLPpQa3_rg41izjQwZPzSsVytMwrNA',
    appId: '1:106748475408:ios:9b86fbb4f59a80853e7295',
    messagingSenderId: '106748475408',
    projectId: 'tuasu-2',
    storageBucket: 'tuasu-2.appspot.com',
    iosBundleId: 'com.example.untitled3',
  );

}