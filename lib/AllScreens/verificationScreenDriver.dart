import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/home.dart';
import 'package:tnrapp/AllScreens/login.dart';
import 'package:tnrapp/AllScreens/loginScreenDriver.dart';
import 'package:tnrapp/AllScreens/registration.dart';
import 'package:tnrapp/AllScreens/registrationDriver.dart';
import 'clipper.dart';

class VerificationDriver extends StatefulWidget {
  static  const String idScreen = "verificationDriver";
  @override
  _VerificationDriverState createState() => _VerificationDriverState();
}

class _VerificationDriverState extends State<VerificationDriver> {
  @override
  Widget build(BuildContext context) {

//GO logo widget
    Widget logo() {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 10,),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, Home.idScreen, (route) => false);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                    height: 2004,
                    child: Column(
                      children: [
                      Align(
                        child: Text(
                          "TRACK \nN\' RIDE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.only(right: 100,),
                          child: Align(
                            child: Text(
                              "DRIVER",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            alignment: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ],
                    ),
                    
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            logo(),
            Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    label: "LOGIN",
                    primaryColor: Theme.of(context).primaryColor,
                    secondaryColor:  Colors.white,
                    onPressed: () { 
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreenDriver.idScreen, (route) => false);
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    label: "REGISTER",
                    primaryColor:  Colors.white,
                    secondaryColor: Theme.of(context).primaryColor,
                    onPressed: () { 
                      Navigator.pushNamedAndRemoveUntil(context, RegisterDriver.idScreen, (route) => false);
                    },
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 80, left: 35, right: 35),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.topCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
      }),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  final String label;
  final Function() onPressed;
  const CustomButton({
    Key key,
    this.primaryColor,
    this.secondaryColor,
    @required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: RaisedButton(
        highlightElevation: 0.0,
        splashColor: secondaryColor,
        highlightColor: primaryColor,
        elevation: 0.0,
        color: primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0), side: BorderSide(color: Theme.of(context).primaryColor, width: 3)),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}