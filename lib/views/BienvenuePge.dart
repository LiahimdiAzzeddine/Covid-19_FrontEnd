import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'info.dart';

class Bienvenue extends StatefulWidget {
  const Bienvenue({Key? key}) : super(key: key);
  @override
  _BienvenueState createState() => _BienvenueState();
}

class _BienvenueState extends State<Bienvenue> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => print(value));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     // backgroundColor: Colors.teal,
      // plusieurs elements horizontaux
      body:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20 ,vertical: 40),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //pour Aligner les ligne
          children: <Widget>[
            SizedBox(
              height: 10,
            ), //pour faire un decalage de 50px
            Container(
              child: Text(
                "Bienvenue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,

                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                        BorderSide(color: Colors.grey.withOpacity(.8)))),
                child: Column(
                  children: <Widget>[
                    Image.asset('images/covid2.png'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 3,
                      ),
                      child: Text(
                        "Soyez alertes et alertez les autres en cas d'exposition à la COVID-19.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                         // color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: Text(
                        "Avec notre application, participez à la lutte contre l'épidémie en réduisant le risque de transmission.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:15,
                         // color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: Text(
                        "Cette application a été réalisée en collaboration avec le Ministère des Solidarités et de la santé publique du Maroc.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          //color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  width: double.infinity,
                  //color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
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
                                    Color(0xFF42A5F5),
                                    Color(0xFF42A5F5),
                                    Color(0xFF1976D2),
                                    Color(0xFF0D47A1),

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
                              onPressed: () {_info(context);},
                              child: const Text('Je veux participer'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),),
    );
  }

  void _info(BuildContext context) {
    final route=MaterialPageRoute(builder: (BuildContext context){
      return info();

    });
    Navigator.of(context).push(route);
  }
}
