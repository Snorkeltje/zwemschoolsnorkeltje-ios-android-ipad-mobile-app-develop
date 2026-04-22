// File generated manually from Firebase config files.
// To regenerate with flutterfire CLI: `flutterfire configure`
//
// iOS:     ios/Runner/GoogleService-Info.plist
// Android: android/app/google-services.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return _web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        return _ios;
      default:
        throw UnsupportedError(
          'Firebase is not configured for ${defaultTargetPlatform.name} yet.',
        );
    }
  }

  static const _android = FirebaseOptions(
    apiKey: 'AIzaSyD5oR6-kMRa0ovv8TwXG3LpRyDn3RFfqPc',
    appId: '1:901428011791:android:d3306acd449daf0b27147a',
    messagingSenderId: '901428011791',
    projectId: 'snorkeltje-project',
    storageBucket: 'snorkeltje-project.firebasestorage.app',
  );

  static const _ios = FirebaseOptions(
    apiKey: 'AIzaSyCmepKaonngTytkaGOzkGfuqGBZ2_kkAzA',
    appId: '1:901428011791:ios:14d2208c92ec44a027147a',
    messagingSenderId: '901428011791',
    projectId: 'snorkeltje-project',
    storageBucket: 'snorkeltje-project.firebasestorage.app',
    iosBundleId: 'nl.snorkeltje.zwemschoolSnorkeltje',
  );

  // Web placeholder — fill in when we deploy web admin dashboard
  static const _web = FirebaseOptions(
    apiKey: 'AIzaSyD5oR6-kMRa0ovv8TwXG3LpRyDn3RFfqPc',
    appId: '1:901428011791:web:placeholder',
    messagingSenderId: '901428011791',
    projectId: 'snorkeltje-project',
    storageBucket: 'snorkeltje-project.firebasestorage.app',
  );
}
