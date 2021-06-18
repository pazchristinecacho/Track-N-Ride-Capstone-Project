import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tnrapp/Assistants/requestAssistant.dart';
import 'package:tnrapp/DataHandler/appData.dart';
import 'package:tnrapp/Models/address.dart';
import 'package:tnrapp/Models/allCommuterUsers.dart';
import 'package:tnrapp/Models/allDriverUsers.dart';
import 'package:tnrapp/Models/directionDetails.dart';
import 'package:tnrapp/configMaps.dart';

class AssistantMethods{
  static Future<String> searchCoordinateAddress(Position position, context) async{
    String placeAddress = "";
    String st1, st2, st3, st4;
    
    //Uri url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude},&key=$mapKey");
    Uri url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey');


    var response = await RequestAssistant.getRequest(url);

    //String jsonsDataString = response.toString();
    //final jsonData = jsonDecode(jsonsDataString);

    if(response != "failed"){
      //placeAddress = response["results"][0]["address_components"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      /*
      st1 = jsonData["results"][0]["address_components"][2]["long_name"].toString();
      //st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = jsonData["results"][0]["address_components"][3]["long_name"].toString();
      st3 = jsonData["results"][0]["address_components"][2]["long_name"].toString();
      st4 = jsonData["results"][0]["address_components"][3]["long_name"].toString();*/
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;
      /*
      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;*/

      //placeAddress = response['results'][0]['formatted_address'];

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      //Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> getPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(Uri.parse(directionUrl));

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;

  }

  static int calculateDistance(DirectionDetails directionDetails){
    double timeTraveledFare = (directionDetails.durationValue/60) * 0.20;
    double distanceTraveledFare = (directionDetails.distanceValue/1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    return totalFareAmount.truncate();

  }

  static void getCurrentOnlineUserInfo() async{
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);
    
    reference.once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null){
        userCurrentinfo = commuterUsers.fromSnapshot(dataSnapShot);
      }
    });
  }

  static void getCurrentOnlineDriverUserInfo() async{
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("userDrivers").child(userId);
    
    reference.once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null){
        driverUserCurrentInfo = driverUsers.fromSnapshot(dataSnapShot);
      }
    });
  }
}