/*
 * Created by Deepak Gupta on 16/12/25
 *  Copyright (c) 2025 . All rights reserved.
 */

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVTzTY85Vp6u2i2YYCwLc2Sfu0ZSQCTn8',
    appId: '1:238002367713:android:909968f5e3bd4cb0481ba0',
    messagingSenderId: '238002367713',
    projectId: 'tys-attendance',
    storageBucket: 'tys-attendance.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAd3oMCsUy_M2tg6VFt1us45tzeIcwOZ98',
    appId: '1:238002367713:ios:3dc9800234383f42481ba0',
    messagingSenderId: '238002367713',
    projectId: 'tys-attendance',
    storageBucket: 'tys-attendance.firebasestorage.app',
    iosBundleId: 'com.tys.tystestapp',
  );
}
