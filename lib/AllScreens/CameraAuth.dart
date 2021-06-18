import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tnrapp/AllScreens/CameraAuthNext.dart';
import 'package:tnrapp/AllScreens/verificationScreenDriver.dart';

class CameraAuthScreen extends StatefulWidget {
  static  const String idScreen = "CameraAuthScreen";

  @override
  _CameraAuthScreenState createState() => _CameraAuthScreenState();
}

class _CameraAuthScreenState extends State<CameraAuthScreen> {

  TextEditingController _licenseName, _licenseBday =  TextEditingController();

  @override
  Widget build(BuildContext context) {

//GO logo widget
    Widget logo() {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.5,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 10,),
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
                ),
              ),
              Positioned(
                child: Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, left: 50,),
                    height: MediaQuery.of(context).size.height/2.5,
                    child: Column(
                      children: [
                      Align(
                        child: Text(
                          "Please verify your identity.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        alignment: Alignment.topLeft
                      ),
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.only(top: 20, right: 25),
                          child: Align(
                            child: Expanded(
                              child: AutoSizeText.rich(
                              TextSpan(text: 'This helps maintain the safety of the community and fight against fraud.\n\nWe\'ll need a Valid ID for verification and you\'ll only need it this once.'),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                              minFontSize: 5,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
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

  void _registerSheet(context) {
      showBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            licenseName: _licenseName,
          );
        },
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
                  SizedBox(height: MediaQuery.of(context).size.height/12),
                  SizedBox(height: 15),

                  Positioned(
                    child: Container(
                      padding: EdgeInsets.only(),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.lock,
                              size: 15.0,
                              color: Colors.grey[800],
                            ),
                          ),

                          Expanded(
                            child: AutoSizeText.rich(
                              TextSpan(text: 'Your ID won\'t be shared with public and will only be used for verification purposes.'),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700],
                              ),
                              minFontSize: 5,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  CustomButton(
                    label: "Begin Verification",
                    primaryColor:  Theme.of(context).primaryColor,
                    secondaryColor: Colors.white,
                    onPressed: () => _registerSheet(context),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 40, left: 35, right: 35),
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
    @required TextEditingController licenseName,
    TextEditingController licenseBday
  })  : _licenseName = licenseName,
        _licenseBday = licenseBday,
        super(key: key);

  final TextEditingController _licenseName;
  final TextEditingController _licenseBday;

  List<Widget> get _registerLogo => [
        Positioned(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              "What's the full name on/your driver's license?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange[400],
              ),
            ),
          ),
        ),
      ];
  List<Widget> get _loginLogo => [
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
                          Navigator.of(context).pop();
                          _licenseName.clear();
                          _licenseBday.clear();
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
                      if (_licenseName != null)
                        
                      CustomTextField(
                        controller: _licenseBday,
                        hint: "MM/DD/YYYY",
                        icon: Icon(Icons.view_day),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                          controller: _licenseName,
                          hint: "Full Name",
                          icon: Icon(Icons.person),
                        ),
                      
                      SizedBox(height: 20),
                      CustomButton(
                        label: "CONTINUE",
                        primaryColor: Theme.of(context).primaryColor,
                        secondaryColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, CameraAuthNext.idScreen, (route) => false);
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
