import 'package:db_qr_code/statistique/details.dart';
import 'package:db_qr_code/views/BienvenuePge.dart';
import 'package:db_qr_code/views/info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
Future  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Anti Covid Projet',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        primarySwatch: Colors.teal,
      ),
      home: const Bienvenue(),
    );
  }
}