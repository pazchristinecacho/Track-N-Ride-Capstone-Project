import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/CameraAuthPic.dart';
import 'package:tnrapp/DriverScreen/HomeDriverScreen.dart';
import 'package:tnrapp/DriverScreen/mainscreenDriver.dart';

class CameraAuthFinished extends StatefulWidget {
  static const String idScreen = "cameraAuthFin";
  @override
  _CameraAuthFinishedState createState() => _CameraAuthFinishedState();
}

class _CameraAuthFinishedState extends State<CameraAuthFinished> {
  @override
  Widget build(BuildContext context) {
//GO logo widget
    Widget logo() {
      return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          CameraAuthPicScreen.idScreen, (route) => false);
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
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: 50,
                  ),
                  height: 400,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Finished!",
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
                          padding: EdgeInsets.only(top: 25),
                          child: Align(
                            child: Text(
                              "We'll review your ID within 3-5 working days.",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            alignment: Alignment.bottomLeft,
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
                      label: "Exit",
                      primaryColor: Theme.of(context).primaryColor,
                      secondaryColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            MainScreenDriver.idScreen, (route) => false);
                      },
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: 40, left: 35, right: 35),
              ),
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
            borderRadius: new BorderRadius.circular(15.0),
            side: BorderSide(color: Theme.of(context).primaryColor, width: 3)),
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
