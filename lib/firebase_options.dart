// GENERATED-LIKE FILE WITH REAL CONFIG VALUES

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ------------ WEB ------------
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyCjcPZlCgTTP7p8hQElokIwWHiTgZvMNeU",
        authDomain: "inventory-manager-7d6fe.firebaseapp.com",
        projectId: "inventory-manager-7d6fe",
        storageBucket: "inventory-manager-7d6fe.firebasestorage.app",
        messagingSenderId: "397313027634",
        appId: "1:397313027634:web:deac86ffab6a5aaab1562b",
        measurementId: "G-1CDZK36DPT",
      );
    }

    // Para plataformas mobile/desktop
    switch (defaultTargetPlatform) {
      // ------------ ANDROID ------------
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: "AIzaSyAdN1CUcpuMiF0trZhROEVWenHCIphOU08",
          appId: "1:397313027634:android:44bee2996857e337b1562b",
          messagingSenderId: "397313027634",
          projectId: "inventory-manager-7d6fe",
          storageBucket: "inventory-manager-7d6fe.firebasestorage.app",
        );

      // ------------ iOS ------------
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: "YOUR_IOS_API_KEY",
          appId: "YOUR_IOS_APP_ID",
          messagingSenderId: "397313027634",
          projectId: "inventory-manager-7d6fe",
          iosBundleId: "com.example.inventoryManager",
          storageBucket: "inventory-manager-7d6fe.firebasestorage.app",
        );

      // ------------ macOS ------------
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: "YOUR_MAC_API_KEY",
          appId: "YOUR_MAC_APP_ID",
          messagingSenderId: "397313027634",
          projectId: "inventory-manager-7d6fe",
          storageBucket: "inventory-manager-7d6fe.firebasestorage.app",
        );

      // ------------ DEFAULT ------------
      default:
        return const FirebaseOptions(
          apiKey: "AIzaSyCjcPZlCgTTP7p8hQElokIwWHiTgZvMNeU",
          appId: "1:397313027634:web:deac86ffab6a5aaab1562b",
          messagingSenderId: "397313027634",
          projectId: "inventory-manager-7d6fe",
          storageBucket: "inventory-manager-7d6fe.firebasestorage.app",
        );
    }
  }
}