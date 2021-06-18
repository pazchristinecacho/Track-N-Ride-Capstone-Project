import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tnrapp/AllScreens/registrationDriver.dart';
import 'package:tnrapp/AllScreens/verificationScreenDriver.dart';
import 'package:tnrapp/DriverScreen/mainscreenDriver.dart';
import 'package:tnrapp/main.dart';

class LoginScreenDriver extends StatelessWidget {
  static  const String idScreen = "loginScreenDriver";

  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();

  TextEditingController phoneTextEditingController = TextEditingController();

  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10,),
          child: Column(
            children: [
              Positioned(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 10,),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, VerificationDriver.idScreen, (route) => false);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20,),
                  child: Text(
                    "Welcome,",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[400],
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Align(
                child: Container(
                  padding: EdgeInsets.only(left: 20,),
                  child: Text(
                    "Sign in as a Driver to Continue!",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.orange[400],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.07, 20, 10),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                                _isObscure = !_isObscure;
                            }),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Align(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    SizedBox(height: 10),
                      CustomButton(
                        label: "Log In",
                        primaryColor: Theme.of(context).primaryColor,
                        secondaryColor: Colors.white,
                        onPressed: () {
                          if (emailTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Email address is empty.", context);
                        } else if (!emailTextEditingController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not Valid.", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage("Password is empty.", context);
                        } else {
                          loginAndAuthenticateUser(context);
                        }
                      },
                      ),
                    
                    SizedBox(height: 45),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10,),),
                  ],
                ),
              ),

              DecoratedBox(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(200.0), topRight: Radius.circular(200.0))),
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 0, right: 0),
                  child: Row(
                      children: <Widget>[
                        Text('Do not have an Account?',
                            style: TextStyle(fontSize: 15,color: Colors.white)),
                        FlatButton(
                          textColor: Colors.white,
                          child: Text(
                            'Register Here',
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, RegisterDriver.idScreen, (route) => false);
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  alignment: Alignment.bottomCenter,
                ),
                ),

            ],)
          ,),
        ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userDriversRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          //Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreenDriver()));
          displayToastMessage("You are now logged in.", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "No record exists for this user. Please create new account.",
              context);
        }
      });
    } else {
      displayToastMessage("Error occured, can not sign in.", context);
    }
  }

}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
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
            borderRadius: new BorderRadius.circular(15.0), side: BorderSide(color: Colors.white, width: 3)),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }
}