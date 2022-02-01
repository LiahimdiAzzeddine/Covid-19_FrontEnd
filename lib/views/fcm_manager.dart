//import 'package:firebase_remote_config/firebase_remote_config.dart';
//import 'package:fcm_http/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_udid/flutter_udid.dart';
import 'package:uuid/uuid.dart';

import 'firebase_config.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print('Handling a background message ${message.messageId}');
}

class FcmManager {
  initFCM() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(message);
    });
    FirebaseMessaging.instance.getToken().then((value) => {_sendData(value)});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _sendData(token) async {
    var client = http.Client();
    String udid;
    try {
      udid = await FlutterUdid.consistentUdid;
    } on PlatformException {
      var uuid = Uuid();
      udid = uuid.v1();
    }
    try {
      var response = await client.post(
          Uri.parse('http://localhost:8080/api/v1/devices'),
          body: {'token': token, 'udid': udid});
      var decodedResponse =
      convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
      var key = decodedResponse['key'] as String;
    } finally {
      client.close();
    }
  }
}
