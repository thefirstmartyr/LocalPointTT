// File generated manually for Firebase configuration
// This file provides Firebase options for different platforms

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyDP6Ds5XxJ8_A8mH9CV2aex3WC9bdGwoCo',
    appId: '1:295446487195:web:78076259bd063d5326663e',
    messagingSenderId: '295446487195',
    projectId: 'localpointtt',
    authDomain: 'localpointtt.firebaseapp.com',
    storageBucket: 'localpointtt.firebasestorage.app',
    measurementId: 'G-L4WB05GKWS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCe9iok2jM87VL37zDdSZTbJX51te-xl9c',
    appId: '1:295446487195:android:2ba86923702577e226663e',
    messagingSenderId: '295446487195',
    projectId: 'localpointtt',
    storageBucket: 'localpointtt.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe9iok2jM87VL37zDdSZTbJX51te-xl9c',
    appId: '1:295446487195:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '295446487195',
    projectId: 'localpointtt',
    storageBucket: 'localpointtt.firebasestorage.app',
    iosBundleId: 'com.localpointtt.app',
  );
}
