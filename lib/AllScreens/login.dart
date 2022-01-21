import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tnrapp/AllScreens/mainscreen.dart';
import 'package:tnrapp/AllScreens/phoneSignIn.dart';
import 'package:tnrapp/AllScreens/registration.dart';
import 'package:tnrapp/AllScreens/verificationScreen.dart';
import 'package:tnrapp/CommuterScreen/HomeCommuterScreen.dart';
import 'package:tnrapp/configMaps.dart';
import 'package:tnrapp/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Column(
            children: [
              Positioned(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          VerificationScreen.idScreen, (route) => false);
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
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
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
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    "Sign in to Continue!",
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
                              setState(() {
                                _isObscure = !_isObscure;
                              });
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
                    /*Align(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PhoneSignInPage()));
                          },
                          child: Text(
                            "Log In with SMS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),*/
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
                    SizedBox(height: 10),
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                      Text("OR"),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                    ]),
                    SizedBox(height: 10),
                    SignInButton(
                      Buttons.Google,
                      text: "Sign In with Google",
                      onPressed: () {
                        signInWithGoogle();
                        /*_googleSignIn.signIn().then((userData) {

                            _isLoggedIn = true;
                            _userObj = userData;
                            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
                          }).catchError((e) {
                            print(e);
                         }); */
                      },
                    ),
                    // Button to go to Phone sign in
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.08,
                      ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(200.0),
                        topRight: Radius.circular(200.0))),
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 0, right: 0),
                  child: Row(
                    children: <Widget>[
                      Text('Do not have an Account?',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      FlatButton(
                        textColor: Colors.white,
                        child: Text(
                          'Register Here',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              RegistrationScreen.idScreen, (route) => false);
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
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
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          //Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          currentfirebaseUser = firebaseUser;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()));
          displayToastMessage("You are now logged in.", context);
        } else {
          Navigator.pop(context);
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    if (googleUser != null) {
      // wrong call in wrong place!
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
            borderRadius: new BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.white, width: 3)),
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
