// GENERATED-LIKE FILE WITH PLACEHOLDER CONFIG
// Substitua pelos valores reais do seu projeto Firebase.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'YOUR_WEB_API_KEY',
        appId: 'YOUR_WEB_APP_ID',
        messagingSenderId: 'YOUR_WEB_SENDER_ID',
        projectId: 'YOUR_PROJECT_ID',
        authDomain: 'YOUR_AUTH_DOMAIN',
        storageBucket: 'YOUR_STORAGE_BUCKET',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'YOUR_ANDROID_API_KEY',
          appId: 'YOUR_ANDROID_APP_ID',
          messagingSenderId: 'YOUR_ANDROID_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_IOS_API_KEY',
          appId: 'YOUR_IOS_APP_ID',
          messagingSenderId: 'YOUR_IOS_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          iosBundleId: 'com.example.inventoryManager',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_MAC_API_KEY',
          appId: 'YOUR_MAC_APP_ID',
          messagingSenderId: 'YOUR_MAC_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      default:
        return const FirebaseOptions(
          apiKey: 'YOUR_DEFAULT_API_KEY',
          appId: 'YOUR_DEFAULT_APP_ID',
          messagingSenderId: 'YOUR_DEFAULT_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
    }
  }
}