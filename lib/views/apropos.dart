import 'package:flutter/material.dart';
import 'BienvenuePge.dart';
import 'Detection.dart';
import 'Home.dart';

class apropos extends StatefulWidget {
  const apropos({Key? key}) : super(key: key);

  @override
  _aproposState createState() => _aproposState();
}
class _aproposState extends State<apropos>{

  void initState() {
    super.initState();
    // Load the save when StatefulWidget is first created
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          _back(context);
        }, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "À propos",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            //color: Colors.white,
          ),
        ),
      ),
      // plusieurs elements horizontaux
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              children: <Widget>[
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
                      image: AssetImage('images/covid6.png'), fit: BoxFit.cover)),),
                InkWell(




                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(

                              "C'est une application mobile de recherche des contacts déployée dans le cadre de la pandémie de Covid-19 en Marocco"
                              " et destinée initialement à avertir d'une éventuelle transmission avec une personne infectée. "
                              "L'application utilise le Bluetooth à basse consommation des téléphones portables compatibles pour identifier les contacts"
                              "Cette application a été réalisée par l'équipe MBD_SIM, sous la supervision de la faculté des sciences et techniques .",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,

                              ),
                        ),
                        SizedBox(height: 5),

                      ],
                    ),
                  ),
                ),
              ],
            ),)
      ),
    );
  }


  void _back(BuildContext context) {
    final route=MaterialPageRoute(builder: (BuildContext context){
      return HomePage();

    });
    Navigator.of(context).push(route);
  }
}

