import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/CameraAuth.dart';
import 'package:tnrapp/AllScreens/CameraAuthPic.dart';

class CameraAuthNext extends StatefulWidget {

  static  const String idScreen = "CameraAuthNextScreen";
  @override
  _CameraAuthNextState createState() => _CameraAuthNextState();
}

class _CameraAuthNextState extends State<CameraAuthNext> {

  TextEditingController _licenseBday =  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15),
                  BottomSheet(licenseBday: _licenseBday),
                ],
              ),
              padding: EdgeInsets.only(top: 40),
            ),
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

class CustomTextField extends StatelessWidget {
  final Icon icon;
  final String hint;
  final TextEditingController controller;
  final bool obsecure;

  const CustomTextField({
    this.controller,
    this.hint,
    this.icon,
    this.obsecure,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecure ?? false,
      style: TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
          ),
          prefixIcon: Padding(
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).primaryColor),
              child: icon,
            ),
            padding: EdgeInsets.only(left: 30, right: 10),
          )),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    Key key,
    TextEditingController licenseName,
    @required TextEditingController licenseBday
  })  : _licenseName = licenseName,
        _licenseBday = licenseBday,
        super(key: key);

  final TextEditingController _licenseName;
  final TextEditingController _licenseBday;


  List<Widget> get _registerLogo => [
              Align(
                child: Container(
                  child: Text(
                    "When's your birthday?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[400],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
            ];
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 10,
                      top: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                height: 50,
                width: 50,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: Stack(
                          children: <Widget>[
                            ..._licenseName!= null ? _registerLogo : _registerLogo
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_licenseBday != null)
                      CustomTextField(
                          controller: _licenseName,
                          hint: "Full Name",
                          icon: Icon(Icons.person),
                        ),
                      
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: _licenseBday,
                        hint: "MM/DD/YYYY",
                        icon: Icon(Icons.view_day),
                      ),
                      
                      SizedBox(height: 20),
                      CustomButton(
                        label: "CONTINUE",
                        primaryColor: Theme.of(context).primaryColor,
                        secondaryColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, CameraAuthPicScreen.idScreen, (route) => false);
                        },
                      ),
                      SizedBox(height: 20),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height / 1.1,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
      ),
    );
  }
}
