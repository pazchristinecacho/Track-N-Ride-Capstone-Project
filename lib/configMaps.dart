import 'package:firebase_auth/firebase_auth.dart';
import 'package:tnrapp/Models/allCommuterUsers.dart';
import 'package:tnrapp/Models/allDriverUsers.dart';

import 'Models/allUsers.dart';

//String mapKey = "AIzaSyADT-U40c_5b1mTmdSCVqCoGuJv8IY9OWY";
String mapKey = "AIzaSyBj5lVfz6WfCLgDFwhODLRO_KrVeyxqJ9k";

User firebaseUser;

User currentfirebaseUser;

Users userCurrentInfo;

//commuterUsers userCurrentinfo;

driverUsers driverUserCurrentInfo;

int driverRequestTimeOut = 40;
String statusRide = "";
String rideStatus = "Driver is Coming";
String carDetailsDriver = "";
String driverName = "";
String driverphone = "";

double starCounter = 0.0;
String title = "";
String carRideType = "";

//String serverToken =
//"key=dxlvY3aERwOXDyCF8pvv1T:APA91bESAfOIhX0WqL_zkIKR_QaETm6ydC6UjXt08tlOL2RyrvijxhH76yi94kk5Sq7s_kejeQFD2CxpHrCeBdjFL3v774fL2gzzQTTUT-OAw0g-1tsYo_vlyZfuaJUyYcNLo1tBTlvK";

String serverToken =
    "key=AAAAcc7yADo:APA91bE0L-hoKuBrVY-FdjYIMPvcU3MPNFubxbHT-LT9H6oA9OzfAuAFiDOHJdTXSSkHFP1BrFGyNYPJNGfsAnxpqtVcOa0_FO9vbRE9Dq6t8hUQyn85bhzO2WuL6WM6NmrLJDdcGG18";
