import 'package:db_qr_code/views/Home.dart';
import 'package:db_qr_code/views/Statistic.dart';
import 'package:db_qr_code/views/fcm_manager.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}
class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}

class _DetailsState extends State<Details> {
  late List<GDPData> _chartData;
  late List<GDPData> _chartData2;
  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior2;
  Map<String, dynamic> data = Map<String, dynamic>();
  @override
  void initState() {
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
          leading: IconButton(onPressed:(){_back(context);}, icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.blue,
          title: Text(
            "STATISTIQUE",
            style: TextStyle(
              fontSize: 24,
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
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35,horizontal: 15),
            child: Center(
              child: Column(
                  children: <Widget>[
                SfCircularChart(
                  title:
                  ChartTitle(text: 'CORONAVIRUS (COVID-19) STATISTIQUES'),
                  legend:
                  Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                  tooltipBehavior: _tooltipBehavior,
                  series: <CircularSeries>[
                    PieSeries<GDPData, String>(
                        dataSource: _chartData,
                        xValueMapper: (GDPData data, _) => data.continent,
                        yValueMapper: (GDPData data, _) => data.gdp,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                        //maximumValue: 40000
                    )
                  ],

                ),
                    SfCircularChart(
                      title:
                      ChartTitle(text: 'TEST PAR POPULATION'),
                      legend:
                      Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                      tooltipBehavior: _tooltipBehavior2,
                      series: <CircularSeries>[
                        PieSeries<GDPData, String>(
                          dataSource: _chartData2,
                          xValueMapper: (GDPData data, _) => data.continent,
                          yValueMapper: (GDPData data, _) => data.gdp,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true,
                          //maximumValue: 40000
                        )
                      ],

                    ),
                ]
              ),
            ),
          ),
        )

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
        _chartData = [
          GDPData('recovered',this.data['recovered']),
          GDPData('active', this.data['active']),
          GDPData('critical',this.data['critical']),
          GDPData('deaths',this.data['deaths']),
        ];
        _chartData2 = [
          GDPData('population',this.data['population']),
          GDPData('tests', this.data['tests']),
        ];
        _tooltipBehavior = TooltipBehavior(enable: true);
        _tooltipBehavior2 = TooltipBehavior(enable: true);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
void _Detection(BuildContext context) {
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
void _back(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return HomePage();

  });
  Navigator.of(context).push(route);
}
void _MyStatistic(BuildContext context) {
  final route=MaterialPageRoute(builder: (BuildContext context){
    return MyStatistic();

  });
  Navigator.of(context).push(route);
}

