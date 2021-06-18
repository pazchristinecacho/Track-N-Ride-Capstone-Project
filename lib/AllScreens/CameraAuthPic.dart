import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/CameraAuth.dart';
import 'package:tnrapp/AllScreens/CameraAuthFinished.dart';
import 'package:tnrapp/AllScreens/CameraAuthNext.dart';

class CameraAuthPicScreen extends StatefulWidget {

  static  const String idScreen = "cameraAuthPic";
  @override
  _CameraAuthPicScreenState createState() => _CameraAuthPicScreenState();
}

class _CameraAuthPicScreenState extends State<CameraAuthPicScreen> {
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
                      Navigator.pushNamedAndRemoveUntil(context, CameraAuthNext.idScreen, (route) => false);
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
                          "Take a Photo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
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
                              "Driver's License",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
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
        return SingleChildScrollView(
          child: Column(
          children: <Widget>[
            logo(),
            Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
                  CustomButton(
                    label: "camera",
                    primaryColor:  Colors.white,
                    secondaryColor: Theme.of(context).primaryColor,
                    onPressed: () { 
                      Navigator.pushNamedAndRemoveUntil(context, CameraAuthFinished.idScreen, (route) => false);
                    },
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 40, left: 35, right: 35),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),);
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
      height: 100,
      width: double.infinity,
      child: RaisedButton(
        highlightElevation: 0.0,
        splashColor: secondaryColor,
        highlightColor: primaryColor,
        elevation: 0.0,
        color: primaryColor,
        shape: CircleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 3)),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}