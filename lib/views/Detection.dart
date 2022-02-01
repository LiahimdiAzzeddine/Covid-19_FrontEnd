import 'dart:convert';
import 'package:db_qr_code/nearby_connections/devices_list_screen2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:uuid/uuid.dart';
import 'api.dart';
import 'firebase_config.dart';
import 'info.dart';
import 'package:device_info/device_info.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Detection extends StatefulWidget {
  const Detection({ Key? key }) : super(key: key);

  @override
  _DetectionState createState() => _DetectionState();
}
//-----------------------------------------------------------------------------------
/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp`
  // using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print('Handling a background message ${message.messageId}');
}*/
//-----------------------------------------------------------------------------------

class _DetectionState extends State<Detection> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String token;
  late String androidId;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => token=value!);
    ajouter();
  }
  Future ajouter() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    androidId = androidInfo.androidId;
  }

  /*_register() async {
    var data={
      'udid':androidId,
      'token':token,
    };
    var res= await CallAp().postData(data,'register');
    print(androidId+"-------------------------- envoyer ------------------------------"+token);
    var body =json.decode(res.body);
  }*/
  //-----------------------------------------------------------------------------------
  /*initFCM() async {
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



    FirebaseMessaging.instance.getToken().then((value)=>print(value));
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }*/


//-----------------------------------------------------------------------------------
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
          Uri.parse('http://192.168.1.9:8000/api/v1/devices'),

          body: {'token': token, 'udid': udid});
      var decodedResponse =
      convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
      var key = decodedResponse['key'] as String;
    
    } finally {
      client.close();
    }
  }
  //-----------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        leading: IconButton(onPressed:(){_back(context);}, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Detection",
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          //color: Colors.blue,
        ),
        ),
      ),
      // plusieurs elements horizontaux
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35,horizontal: 15),
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset('images/bluetooth.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Autoriser les 'contacts Bluetooth'",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    //color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "TousAntiCovid a besoin d'utiliser le Bluetooth de votre telephone pour fonctionner. aucune donnee de geolocalisation n'est echangee ou enrgistree.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    //color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      width: double.infinity,
                      //color: Colors.tealAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(8.0),
                                    primary: Colors.white,
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    FirebaseMessaging.instance.getToken().then((value) => {_sendData(value)});
                                    _home(context);
                                  },

                                  child: const Text('Autoriser'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void _back(BuildContext context) {
    final route=MaterialPageRoute(builder: (BuildContext context){
      return info();

    });
    Navigator.of(context).push(route);
  }
  void _home(BuildContext context) {
    final route=MaterialPageRoute(builder: (BuildContext context){
      return DevicesListScreen();

    });
    Navigator.of(context).push(route);
  }
}