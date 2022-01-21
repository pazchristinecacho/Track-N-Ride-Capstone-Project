import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/mainscreen.dart';

class AboutScreen extends StatefulWidget {
  static const String idScreen = "about";

  @override
  _MyAboutScreenState createState() => _MyAboutScreenState();
}

class _MyAboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Container(
              height: 200,
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(20),
              child: Center(
                child: Image.asset('images/tnrlogo.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 24, right: 24),
              child: Column(
                children: <Widget>[
                  Text(
                    'Track N Ride',
                    style: TextStyle(fontSize: 90, fontFamily: 'Signatra'),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'This app has been developed for a convenient, '
                    'public transportation. This app offers real-time hailing of rides, '
                    'either through taxi, tricyle, or jeep,',
                    style: TextStyle(fontFamily: "Brand-Bold"),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                },
                child: const Text('Go Back',
                    style: TextStyle(fontSize: 18, color: Colors.orange)),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0))),
          ],
        ));
  }
}
