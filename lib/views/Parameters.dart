import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'BienvenuePge.dart';
import 'Detection.dart';
import 'Home.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class parameters extends StatefulWidget {
  const parameters({Key? key}) : super(key: key);

  @override
  _parametersState createState() => _parametersState();
}
class _parametersState extends State<parameters>{
  double _slider = 0.5;
  bool _switch = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Paramètre',style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,

      ),
      child: CupertinoSettings(
        items: <Widget>[
          const CSHeader('Luminosité'),
          CSWidget(
            CupertinoSlider(
              value: _slider,
              onChanged: (double value) => setState(() => _slider = value),
            ),
            style: CSWidgetStyle(
              icon: Icon(FontAwesomeIcons.sun),
            ),
            addPaddingToBorder: true,
          ),
          CSControl(
            nameWidget: Text('Auto Luminosité'),
            contentWidget: CupertinoSwitch(
              value: _switch,
              onChanged: (bool value) => setState(() => _switch = value),
            ),
            style: CSWidgetStyle(
              icon: Icon(FontAwesomeIcons.sun),
            ),
            addPaddingToBorder: false,
          ),
          const CSHeader('Selection'),
          CSSelection<int>(
            items: const <CSSelectionItem<int>>[
              CSSelectionItem<int>(text: 'Day mode', value: 0),
              CSSelectionItem<int>(text: 'Night mode', value: 1, subtitle: 'Subtitle'),
            ],
            onSelected: (value) => setState(() => _index = value),
            currentSelection: _index,
          ),
          const CSHeader('les langues'),
          CSSelection<int>(
            items: const <CSSelectionItem<int>>[
              CSSelectionItem<int>(text: 'Français', value: 0),
              CSSelectionItem<int>(text: 'English', value: 1),
              CSSelectionItem<int>(text: 'العربية', value: 2),
            ],
            onSelected: (value) => setState(() => _index = value),
            currentSelection: _index,
          ),
          const CSDescription(
            'choisir la langue qui vous voulez !',
          ),
          const CSHeader(""),


        ],
      ),
    );
  }
  }
  void _back(BuildContext context) {
    final route=MaterialPageRoute(builder: (BuildContext context){
      return HomePage();

    });
    Navigator.of(context).push(route);
  }


