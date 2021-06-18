import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tnrapp/AllScreens/CameraAuth.dart';
import 'package:tnrapp/AllScreens/CameraAuthFinished.dart';
import 'package:tnrapp/AllScreens/CameraAuthNext.dart';
import 'package:tnrapp/AllScreens/CameraAuthPic.dart';
import 'package:tnrapp/AllScreens/home.dart';
import 'package:tnrapp/AllScreens/login.dart';
import 'package:tnrapp/AllScreens/loginScreenDriver.dart';
import 'package:tnrapp/AllScreens/mainscreen.dart';
import 'package:tnrapp/AllScreens/registration.dart';
import 'package:tnrapp/AllScreens/registrationDriver.dart';
import 'package:tnrapp/AllScreens/registrationFormDriver.dart';
import 'package:tnrapp/AllScreens/verificationScreen.dart';
import 'package:tnrapp/AllScreens/verificationScreenDriver.dart';
import 'package:tnrapp/CommuterScreen/HomeCommuterScreen.dart';
import 'package:tnrapp/DataHandler/appData.dart';
import 'package:tnrapp/DriverScreen/HomeDriverScreen.dart';
import 'package:tnrapp/DriverScreen/mainscreenDriver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference userDriversRef = FirebaseDatabase.instance.reference().child("userDrivers");

class MyApp extends StatelessWidget {
  static  const String idScreen = "main";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Track N Ride',
        theme: ThemeData(
          hintColor: Colors.orange[200],
          fontFamily: "Roboto",
          primaryColor: Colors.orange[400],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: login(),
        initialRoute: Home.idScreen,
        //initialRoute: FirebaseAuth.instance.currentUser == null ? Home.idScreen : MainScreen.idScreen,
        routes: {
          VerificationScreen.idScreen: (context) => VerificationScreen(),
          VerificationDriver.idScreen: (context) => VerificationDriver(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          LoginScreenDriver.idScreen: (context) => LoginScreenDriver(),
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          RegisterDriver.idScreen: (context) => RegisterDriver(),
          RegistrationFormDriver.idScreen: (context) => RegistrationFormDriver(),
          CameraAuthScreen.idScreen: (context) => CameraAuthScreen(),
          CameraAuthNext.idScreen: (context) => CameraAuthNext(),
          CameraAuthPicScreen.idScreen: (context) => CameraAuthPicScreen(),
          CameraAuthFinished.idScreen: (context) => CameraAuthFinished(),
          Home.idScreen: (context) => Home(),
          MainScreen.idScreen: (context) => MainScreen(),
          MainScreenDriver.idScreen: (context) => MainScreenDriver(),
          HomeCommuterScreen.idScreen: (context) => HomeCommuterScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}