import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'package:db_qr_code/views/Home.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'Parameters.dart';
import 'apropos.dart';
import 'fcm_manager.dart';
import 'helper.dart';
import 'package:flutter/cupertino.dart';


class DatatChart extends StatefulWidget {
  const DatatChart({Key? key}) : super(key: key);
  _DatatChartState createState() => _DatatChartState();
}

class  _DatatChartState extends State<DatatChart> {
  String formatter = DateFormat.yMMMMd('en_US').format(new DateTime.now());
  Map<String, dynamic> dataGetted = Map<String, dynamic>();

  Future<void> _sendData() async {
    showLoader(context);
    var url = Uri.parse(
        'https://disease.sh/v3/covid-19/historical/all?lastdays=marocco');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        this.dataGetted = convert.jsonDecode(response.body) as Map<String, dynamic>;
      });
    }
    else {
      print('Request failed with status: ${response.statusCode}.');
    }
    hideLoader(context);
  }
  List<_ChartData> data1=[];
  List<_ChartData> data2=[];
  List<_ChartData> data3=[];
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  initData() async {
    var url = Uri.parse(
        'https://disease.sh/v3/covid-19/historical/all?lastdays=marocco');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        this.dataGetted = convert.jsonDecode(response.body) as Map<String, dynamic>;
        //print( "les donnees "+dataGetted['deaths'].toString());
        for(final key3 in dataGetted['cases'].keys){
          final value3 = dataGetted['cases'][key3].toString();
          double val3=double.parse(value3);
          data1.add(_ChartData(key3,val3));
          //print(val);
        };
        for(final key in dataGetted['deaths'].keys){
          final value = dataGetted['deaths'][key].toString();
          double val=double.parse(value);
          data2.add(_ChartData(key,val));
         // print(val);
        };
        for(final key2 in dataGetted['recovered'].keys){
          final value2 = dataGetted['recovered'][key2].toString();
          double val2=double.parse(value2);
          data3.add(_ChartData(key2,val2));
        }


      }
      );

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FcmManager fcm = FcmManager();
    fcm.initFCM();
    this.initData();
  //  this.RemplirData();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('La couverture vaccinale'),
          backgroundColor: Colors.blue,
        ),
        resizeToAvoidBottomInset: false,
        body:Center(
        child: SingleChildScrollView( child:
        Column(
            children: [
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width ,
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Icon(Icons.share,color: Colors.blue),
                        Text('Donnée du : '+formatter+'',textAlign: TextAlign.left),
                        Text('Couverture vaccinale au maroc' ,style: TextStyle(color: Colors.blue,
                            fontSize: 18,fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 17.0,
                        ),
                        Text('La mesure a été annoncée à peine trois jours avant son application.'
                        'Le Maroc, champion de la vaccination en Afrique, a vacciné près de 58 % de sa population',
                          style: TextStyle(color: Colors.black, fontSize: 14,letterSpacing: 1)),
                        SizedBox(
                          height: 20.0,
                        ),
                       // Text(dataGetted['deaths'].keys.toString())
                       //Text(""+data2.toString())
                      ],
                    ),

                  ),
                  elevation: 10,
                ),
              ),

      Container(

            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          SizedBox(height: 5.0),
          Text('les dernières statistiques au maroc', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
          DefaultTabController(
              length: 3, // length of tabs
              initialIndex: 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                Container(
                  child: TabBar(
                    labelColor: Colors.cyan,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: ' Cas'),
                      Tab(text: 'Rétablie'),
                      Tab(text: 'Décès'),


                    ],
                  ),
                ),
                Container(
                    height: 400, //height of TabBarView
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                    ),
                    child: TabBarView(children: <Widget>[
                      SfCartesianChart(
                          margin: const EdgeInsets.all(10.0),
                          primaryXAxis: CategoryAxis(),
                          legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<_ChartData, String>>[
                            LineSeries<_ChartData, String>(
                              dataSource: this.data1,
                              color: Colors.orange,
                              xValueMapper: (_ChartData cas, _) => cas.x,
                              yValueMapper: (_ChartData cas, _) => cas.y,),

                          ]),
                        SfCartesianChart(
                    margin: const EdgeInsets.all(5.0),
                   primaryXAxis: CategoryAxis(),
              // Chart title
              //title: ChartTitle(text: 'décès'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, String>>[
                LineSeries<_ChartData, String>(
                    dataSource: this.data2,
                    xValueMapper: (_ChartData recovred, _) => recovred.x,
                    yValueMapper: (_ChartData recovred, _) => recovred.y,),


              ]),

                         SfCartesianChart(
              margin: const EdgeInsets.all(5.0),
              primaryXAxis: CategoryAxis(),

              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, String>>[
                LineSeries<_ChartData, String>(
                  color: Colors.red,
                  dataSource: this.data3,
                  xValueMapper: (_ChartData deaths, _) => deaths.x,
                  yValueMapper: (_ChartData deaths, _) => deaths.y,),

              ]),




                    ])
                )
              ])
          ),
        ]),
      ),


            /*********************************/
            ]
        ),
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
    );
  }

}
class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
void _Home(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return HomePage();

  });
  Navigator.of(context).push(route);
}



void _parameters(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return parameters();

  });
  Navigator.of(context).push(route);
}

void _apropos(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return apropos();

  });
  Navigator.of(context).push(route);
}