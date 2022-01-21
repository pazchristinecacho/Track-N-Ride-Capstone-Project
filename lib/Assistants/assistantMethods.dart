import 'dart:convert';
import 'dart:math';
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
import 'package:tnrapp/Models/history.dart';
import 'package:tnrapp/configMaps.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tnrapp/main.dart';

import '../Models/allUsers.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;

    //Uri url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude},&key=$mapKey");
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey');

    var response = await RequestAssistant.getRequest(url);

    //String jsonsDataString = response.toString();
    //final jsonData = jsonDecode(jsonsDataString);

    if (response != "failed") {
      //placeAddress = response["results"][0]["address_components"];
      st1 = response["results"][0]["address_components"][1]["long_name"];
      st2 = response["results"][0]["address_components"][2]["long_name"];
      st3 = response["results"][0]["address_components"][3]["long_name"];
      st4 = response["results"][0]["address_components"][4]["long_name"];
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
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> getPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(Uri.parse(directionUrl));

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateDistance(DirectionDetails directionDetails) {
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    return totalFareAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });
  }

  static void getCurrentOnlineDriverUserInfo() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("drivers").child(userId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        driverUserCurrentInfo = driverUsers.fromSnapshot(dataSnapShot);
      }
    });
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }

  static sendNotificationToDriver(
      String token, context, String ride_request_id) async {
    var destionation =
        Provider.of<AppData>(context, listen: false).dropOffLocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'body': 'Destination Address, ${destionation.placeName}',
      'title': 'New Ride Request'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': ride_request_id,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }

  //history

  static void retrieveHistoryInfo(context) {
    //retrieve and display Trip History
    rideRequestRef
        .orderByChild("rider_name")
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        //update total number of trip counts to provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripsCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      rideRequestRef.child(key).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          rideRequestRef
              .child(key)
              .child("rider_name")
              .once()
              .then((DataSnapshot snap) {
            String name = snap.value.toString();
            if (name == userCurrentInfo.name) {
              var history = History.fromSnapshot(snapshot);
              Provider.of<AppData>(context, listen: false)
                  .updateTripHistoryData(history);
            }
          });
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms Philippine Peso
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distancTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    //Local Currency
    //double totalLocalAmount = totalFareAmount * 160;

    return totalFareAmount.truncate();
  }
}
