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
    apiKey: 'AIzaSyAlwd_NpA3b872j4uectYTR2ooSlW5msMg',
    appId: '1:751628143025:web:aeebe25c92ac27d7169590',
    messagingSenderId: '751628143025',
    projectId: 'recipeapp-54e86',
    authDomain: 'recipeapp-54e86.firebaseapp.com',
    storageBucket: 'recipeapp-54e86.appspot.com',
    measurementId: 'G-RHFQQRV7QB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRtASFtBbwxq7wrMPLVOhmFrEfZBkyB1o',
    appId: '1:751628143025:android:9c26d40ae4b3b9b3169590',
    messagingSenderId: '751628143025',
    projectId: 'recipeapp-54e86',
    storageBucket: 'recipeapp-54e86.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmTjxJfoR1wZ_e7VZrzlXbad00lIy-klA',
    appId: '1:751628143025:ios:cd47485753b2ee51169590',
    messagingSenderId: '751628143025',
    projectId: 'recipeapp-54e86',
    storageBucket: 'recipeapp-54e86.appspot.com',
    androidClientId:
        '751628143025-9n4oustfok35q3av2uhtga7ao7ne21j0.apps.googleusercontent.com',
    iosClientId:
        '751628143025-kn6jnvcqpmv5rsi6tbb05fvme8jem3cc.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDmTjxJfoR1wZ_e7VZrzlXbad00lIy-klA',
    appId: '1:751628143025:ios:edbba9affd7834a9169590',
    messagingSenderId: '751628143025',
    projectId: 'recipeapp-54e86',
    storageBucket: 'recipeapp-54e86.appspot.com',
    androidClientId:
        '751628143025-9n4oustfok35q3av2uhtga7ao7ne21j0.apps.googleusercontent.com',
    iosClientId:
        '751628143025-q2vten03se7isno3bc7kgrrs6ms20oeg.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
