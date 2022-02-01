import 'package:db_qr_code/statistique/details.dart';
import 'package:db_qr_code/views/BienvenuePge.dart';
import 'package:db_qr_code/views/apropos.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'DataChart.dart';
import 'Parameters.dart';
import 'Statistic.dart';
import 'helper.dart';
import 'liteQr.dart';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:db_qr_code/qr_code_screen.dart';
import 'fcm_manager.dart';
import 'package:http/http.dart' as http;

//import 'package:fcm_http/fcm_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> data = Map<String, dynamic>();
  String formatter = DateFormat.yMMMMd('en_US').format(new DateTime.now());

  Future<void> _sendData() async {
    showLoader(context);
    var url = Uri.parse(
        'https://corona.lmao.ninja/v2/countries/Morocco?yesterday=false&strict=true&query =');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        this.data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    hideLoader(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FcmManager fcm = FcmManager();
    fcm.initFCM();
    this.initData();
  }
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Page d'accueil",
            style: TextStyle(
              fontSize: 22,
              //fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Stack(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: Icon(Icons.add_alert_sharp),
                    onPressed: () {
                      _Detection(context);
                    },
                  ),
                ),
                Positioned(
                  right: 9,
                  top: 10,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
              ],
            )
          ],
        ),
        //-------------------------------------------------fin AppBar ----------------------------------------
        body: SingleChildScrollView(
          child: Column(
            children: [
             // SizedBox(height: 10),
            Container(
                width: double.infinity,
                height: 210,
                //padding: EdgeInsets.all(7),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                   // borderRadius: BorderRadius.circular(5),
                   /* boxShadow: [
                      BoxShadow(
                          color: Colors.black26, offset: Offset(2, 2), blurRadius: 10.0)
                    ],*/
                    image: DecorationImage(
                        image: AssetImage('images/covid6.png'), fit: BoxFit.cover)),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 180,
                     /* child: Text(
                        'Covid au maroc',
                        style: TextStyle(color: Colors.teal, fontSize: 25,fontWeight: FontWeight.bold,),
                      ),*/
                    ),
                    Positioned(
                      right: 115,
                      top: 145,
                      width: 130,
                      child: Container(
                        child: RaisedButton(
                          onPressed: () {_Details(context);},
                          color: Colors.red,
                          textColor: Colors.white,
                          child: Text('Détails',
                            style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                    )],
                )
            ),
             // SizedBox(height: 10),

           //   lineSection,

              //-------------------------------------------------Box secton ----------------------------------------

              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                             // boxShadow:
                            ),
                            child: InkWell(
                              onTap: () {
                                _Detection(context);
                              },
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Scanner')
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Paramètres')
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),

                      child: InkWell(
                        onTap: () {
                          _apropos(context);
                        },
                            child: Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),),
                          SizedBox(height: 5),
                          Text('À propos')
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                _Detection(context);
                              },
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Position')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //-------------------------------------------------fin icons section ----------------------------------------
              lineSection,
              //subTitleSection,
              SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 200,
                child: Card (
                  margin: EdgeInsets.all(10),
                  //color: Colors.green[100],
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _MyStatistic(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'les données de '+formatter,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10,color: Colors.grey),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data['tests'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total des tests effectués jusqu''à maintenant',
                                //textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.cyan, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 200,
                child: Card (
                  margin: EdgeInsets.all(10),
                  //color: Colors.green[100],
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _MyStatistic(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'les données de '+formatter,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10,color: Colors.grey),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data['deaths'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Nombre des décès au niveau de marocco jusqu''à maintenant',
                                //textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 200,
                child: Card (
                  margin: EdgeInsets.all(10),
                  //color: Colors.green[100],
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _MyStatistic(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'les données de '+formatter,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10,color: Colors.grey),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data['testsPerOneMillion'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Nombre des tests par million ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 200,
                child: Card (
                  margin: EdgeInsets.all(10),
                  //color: Colors.green[100],
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _MyStatistic(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'les données de '+formatter,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10,color: Colors.grey),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data['todayDeaths'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Nombre des personnes décès aujourd''hui',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 200,
                child: Card (
                  margin: EdgeInsets.all(10),
                  //color: Colors.green[100],
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _MyStatistic(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'les données de '+formatter,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontSize: 10,color: Colors.grey),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data['todayRecovered'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'aujourd''hui récupéré',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.teal, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

            ],
          ),
        ),
        /***************** Fancy Bar ***********/
        bottomNavigationBar: FancyBottomNavigation(
          //circleColor: Colors.teal,
         // inactiveIconColor: Colors.teal,
          tabs: [
            TabData(
                iconData: Icons.home,
                title: "Accueil",
                onclick: () {
                  final FancyBottomNavigationState fState = bottomNavigationKey
                      .currentState as FancyBottomNavigationState;
                  fState.setPage(3);
                }
                ),
            TabData(
                iconData: Icons.analytics,
                title: "Statistiques",
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => DatatChart()))),
            TabData(
                iconData: Icons.account_balance_wallet,
                title: "Mon portefeuille",
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => apropos()))
            ),
            TabData(iconData: Icons.settings,
                title: "Paramètres",
                onclick: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => parameters()))

            )
          ],
          initialSelection: 1,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
        /**************************/
      ),
    );
  }
  initData() async {
    var url = Uri.parse(
        'https://corona.lmao.ninja/v2/countries/Morocco?yesterday=false&strict=true&query =');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        this.data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}

Widget containerSection = Container(
  height: 200,
  width: double.infinity,
  margin: EdgeInsets.all(20),
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(color: Colors.black26, offset: Offset(0, 20), blurRadius: 10.0)
    ],
    borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.orange,
        //Colors.green,
      ],
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Titre',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      Text('Sous-titre'),
      RaisedButton(
        onPressed: () {},
        color: Colors.orange,
        textColor: Colors.white,
        child: Text('Acheter'),
      )
    ],
  ),
);

Widget rowSection = Container(
  color: Colors.black,
  height: 100,
  margin: EdgeInsets.all(20),
  child: Row(
    children: [
      Container(
        color: Colors.blue,
        height: 100,
        width: 100,
      ),
      Expanded(
        child: Container(
          color: Colors.amber,
        ),
      ),
      Container(
        color: Colors.purple,
        height: 100,
        width: 100,
      ),
    ],
  ),
);

void _Detection(BuildContext context) {
  final route = MaterialPageRoute(builder: (BuildContext context) {
    return const MyHomePage(
      title: 'Qr Code Scanner',
    );
  });
  Navigator.of(context).push(route);
}

void _Details (BuildContext context) {
  final route = MaterialPageRoute(builder: (BuildContext context) {

    return const Details(
    );
  });
  Navigator.of(context).push(route);
}
void Statistic(BuildContext context) {
  final route = MaterialPageRoute(builder: (BuildContext context) {
    return const MyStatistic();
  });
  Navigator.of(context).push(route);
}

Widget lineSection = Container(
  color: Colors.grey[200],
  padding: EdgeInsets.all(4),
);

Widget subTitleSection = Container(
  margin: EdgeInsets.all(20),
  child: Row(
    children: [
      Container(
        color: Colors.indigoAccent,
        width: 5,
        height: 25,
      ),
      SizedBox(width: 10),
      Text(
        'Curriculum',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      )
    ],
  ),
);

void _MyStatistic(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return MyStatistic();

  });
  Navigator.of(context).push(route);
}
void _DatatChart(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return DatatChart();

  });
  Navigator.of(context).push(route);
}

void _apropos(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return apropos();

  });
  Navigator.of(context).push(route);
}


