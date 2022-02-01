import 'package:db_qr_code/details_display_screen.dart';
import 'package:db_qr_code/intances.dart';
import 'package:db_qr_code/qr_code.dart';
import 'package:db_qr_code/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
//flutter packages pub run build_runner build

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    myData.initDb(callbackList);
  }

  void _addQrCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrCodeScreen(callback: callback)),
    );
  }

  void callback(MyQrCode qrCode) {
    setState(() {
      myData.qrCodes?.add(qrCode);
    });
  }

  void callbackList(List<MyQrCode> qrCodes) {
    setState(() {
      myData.qrCodes = qrCodes;
    });
  }

  static const IconData qr_code_scanner_rounded =
  IconData(0xf00cc, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: myData.qrCodes != null
              ? ListView.builder(
              itemCount: myData.qrCodes?.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsDisplayScreen(
                          callBack: callbackList,
                          qrCode: myData.qrCodes![index],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: QrImage(
                      data: myData.qrCodes![index].content.toString(),
                      version: QrVersions.auto,
                      size: 50.0,
                    ),
                    title: Text(myData.qrCodes![index].type.toString()),
                    subtitle: Text(formatDate(myData.qrCodes![index].date)),
                  ),
                );
              })
              : const CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQrCode,
        tooltip: 'New QrCode',
        child: const Icon(qr_code_scanner_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
