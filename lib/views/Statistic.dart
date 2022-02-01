import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';

import 'fcm_manager.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

class MyStatistic extends StatefulWidget {
  const MyStatistic({Key? key}) : super(key: key);

  @override
  _MyStatisticState createState() => _MyStatisticState();
}

class _MyStatisticState extends State<MyStatistic> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistiques du COVID',
      //backgroundColor: Colors.yellowAccent,
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (
          Locale? locale,
          Iterable<Locale> supportedLocales,
          ) {
        return locale;
      },
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr', ''),
        Locale('en', ''),
        Locale('ar', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: const Statistic(title: 'Statistiques du COVID'),

    );
  }
}

class Statistic extends StatefulWidget {
  const Statistic({ Key? key ,required this.title}): super(key: key);
  final String title;
  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  Map<String, dynamic> data = Map<String, dynamic>();

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

  buildHome() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),

              child: Card(

                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.totalcases,
                         textAlign: TextAlign.center,
                         style: TextStyle(
                         fontSize: 17,
                         fontWeight: FontWeight.bold,
                         color: Colors.red,
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['cases'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text("Les cas d'aujourd'hui",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                         ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['todayCases'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text("Total des décès",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['deaths'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text("Les décès du jour",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                         ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['todayDeaths'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text("Total récupéré",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),

                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['recovered'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text("Aujourd'hui récupéré",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['todayRecovered'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),

              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),

                  child: Column(
                    children: [
                      Text("Total des tests",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,

                      ),
                      Text(data['tests'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        "Tests / millions",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(data['testsPerOneMillion'].toString())
                    ],
                  ),
                ),
                elevation: 10,
              ),
            )
          ],
        )
      ],
    );
  }

  initData() async {
    var url2 = Uri.parse(
        'https://corona.lmao.ninja/v2/countries/Morocco?yesterday=false&strict=true&query =');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url2);
    if (response.statusCode == 200) {
      setState(() {
        this.data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

       title: Text(widget.title),
      ),
      body: Center(
        child: data.length > 0 ? buildHome() : CircularProgressIndicator(),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: _sendData,
        tooltip: 'refresh',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
