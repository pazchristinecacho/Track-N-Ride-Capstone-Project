import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tnrapp/AllScreens/home.dart';
import 'package:tnrapp/AllScreens/login.dart';
import 'package:tnrapp/AllScreens/phoneSignIn.dart';
import 'package:tnrapp/AllScreens/registration.dart';
import 'clipper.dart';
import 'mainscreen.dart';

class VerificationScreen extends StatefulWidget {
  static const String idScreen = "verification";

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
//GO logo widget
    Widget logo() {
      return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, Home.idScreen, (route) => false);
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
                    height: 104,
                    child: Align(
                      child: /**/
                          Image(
                        image: AssetImage("images/tnrlogo.png"),
                        width: 390.0,
                        height: 250.0,
                        alignment: Alignment.center,
                      ),
                    )),
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
                    secondaryColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    label: "REGISTER",
                    primaryColor: Colors.white,
                    secondaryColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          RegistrationScreen.idScreen, (route) => false);
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
                  /*
                  OutlineButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneSignInPage()),
                      );
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.blueAccent,
                    child: Text("Sign In with SMS\u2192"),
                  ),*/
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
