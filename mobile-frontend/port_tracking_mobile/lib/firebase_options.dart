import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: "AIzaSyBY9nfAMK6UjlCgD4UEtXcqWHwfjpq0T2w",
          appId: "1:223916243427:android:9462822a8d268ac99408d6",
          messagingSenderId: "223916243427",
          projectId: "limangemitakipsistemi",
          storageBucket: "limangemitakipsistemi.appspot.com",
        );
      default:
        throw UnsupportedError(
          'Bu platform için FirebaseOptions tanımlanmadı.',
        );
    }
  }
}
