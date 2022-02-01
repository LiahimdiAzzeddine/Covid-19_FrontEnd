import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS
      return const FirebaseOptions(
        appId: '1:723581440577:ios:8812e20c1f120f4de72cc0',
        apiKey: 'AIzaSyAHTwcJexT0Ikth0d2wbrXmL5RrCSsxUT0',
        projectId: 'myfirebase-a5d22',
        messagingSenderId: '723581440577',
        iosBundleId: 'com.http.fcm',
      );
    } else {
      // Android
      return const FirebaseOptions(
        apiKey: 'AIzaSyAHTwcJexT0Ikth0d2wbrXmL5RrCSsxUT0',
        appId: '1:723581440577:android:506576c316f95d24e72cc0',
        messagingSenderId: '723581440577',
        projectId: 'myfirebase-a5d22',
      );
    }
  }
}