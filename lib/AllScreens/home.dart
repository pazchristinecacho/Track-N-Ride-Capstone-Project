import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/verificationScreen.dart';
import 'package:tnrapp/AllScreens/verificationScreenDriver.dart';
import 'clipper.dart';

class Home extends StatefulWidget {
  static  const String idScreen = "home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

        //GO logo widget
    Widget logo() {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 180,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                    height: 154,
                    child: Align(
                      child: Text(
                        "TRACK \nN\' RIDE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              logo(),
              Padding(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        label: "DRIVER",
                        primaryColor: Colors.white,
                        secondaryColor:  Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.drive_eta_outlined,
                          size: 50.0,
                          color: Theme.of(context).primaryColor,),
                        onPressed: () { 
                          Navigator.pushNamedAndRemoveUntil(context, VerificationDriver.idScreen, (route) => false);
                        },
                      ),
                      SizedBox(height: 20, width: 20,),
                      CustomButton(
                        label: "COMMUTER",
                        primaryColor:  Theme.of(context).primaryColor,
                        secondaryColor: Colors.white,
                        icon: Icon(
                          Icons.person,
                          size: 50.0,
                          color: Colors.white,),
                        onPressed: () { 
                          Navigator.pushNamedAndRemoveUntil(context, VerificationScreen.idScreen, (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.only(top: 80, left: 35, right: 35),
              ),
              Expanded(
                child: Align(
                  child: ClipPath(
                    child: Container(
                      color: Colors.white,
                      height: 300,
                    ),
                    clipper: BottomWaveClipper(),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        );
      }),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Icon icon;

  final String label;
  final Function() onPressed;
  const CustomButton({
    Key key,
    this.primaryColor,
    this.secondaryColor,
    this.icon,
    @required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width/2.75,
      child: RaisedButton(
        highlightElevation: 0.0,
        splashColor: secondaryColor,
        highlightColor: primaryColor,
        elevation: 0.0,
        color: primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0), side: BorderSide(color: Colors.white, width: 3)),
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Container(padding: EdgeInsets.all(25,), child: icon,),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 15),)
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}