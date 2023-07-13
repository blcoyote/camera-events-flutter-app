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
    apiKey: 'AIzaSyDyAoCl_RFWGwPXw2WjVltlOOZZKJ7rD2g',
    appId: '1:248133674895:web:9f8c84fc22ac8810e98dfa',
    messagingSenderId: '248133674895',
    projectId: 'camera-events-f329e',
    authDomain: 'camera-events-f329e.firebaseapp.com',
    storageBucket: 'camera-events-f329e.appspot.com',
    measurementId: 'G-K05M8JYQTL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQuDIv3t-KBlxgtgrSRJ07u1gf_ta_gD0',
    appId: '1:248133674895:android:b85f291869601dc1e98dfa',
    messagingSenderId: '248133674895',
    projectId: 'camera-events-f329e',
    storageBucket: 'camera-events-f329e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCN5592oX95-wr6pEwVhWs6PqdbZ1RpKkE',
    appId: '1:248133674895:ios:21c84cc2399ed46ae98dfa',
    messagingSenderId: '248133674895',
    projectId: 'camera-events-f329e',
    storageBucket: 'camera-events-f329e.appspot.com',
    iosClientId: '248133674895-s5s4j39d0o0g43bvagpon6cb045a0208.apps.googleusercontent.com',
    iosBundleId: 'com.elcoyote.cameraevents',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCN5592oX95-wr6pEwVhWs6PqdbZ1RpKkE',
    appId: '1:248133674895:ios:7070e6dd0780c14fe98dfa',
    messagingSenderId: '248133674895',
    projectId: 'camera-events-f329e',
    storageBucket: 'camera-events-f329e.appspot.com',
    iosClientId: '248133674895-8c1dlqpsg0qikkfd7qea6bo912ah942s.apps.googleusercontent.com',
    iosBundleId: 'com.elcoyote.cameraevents.RunnerTests',
  );
}