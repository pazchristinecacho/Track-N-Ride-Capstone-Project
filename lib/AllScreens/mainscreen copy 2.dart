import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tnrapp/AllScreens/HistoryScreen.dart';
import 'package:tnrapp/AllScreens/aboutScreen.dart';
import 'package:tnrapp/AllScreens/ratingScreen.dart';
import 'package:tnrapp/AllScreens/login.dart';
import 'package:tnrapp/AllScreens/searchScreen.dart';
import 'package:tnrapp/AllWidgets/CollectFareDialog.dart';
import 'package:tnrapp/AllWidgets/Divider.dart';
import 'package:tnrapp/AllWidgets/progressDialog.dart';
import 'package:tnrapp/Assistants/assistantMethods.dart';
import 'package:tnrapp/Assistants/geoFireAssistant.dart';
import 'package:tnrapp/Assistants/requestAssistant.dart';
import 'package:tnrapp/CommuterScreen/ChatPage.dart';
import 'package:tnrapp/CommuterScreen/Profile.dart';
import 'package:tnrapp/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tnrapp/Models/address.dart';
import 'package:tnrapp/Models/history.dart';
import 'package:tnrapp/Models/directionDetails.dart';
import 'package:tnrapp/Models/nearbyAvailableDrivers.dart';
import 'package:tnrapp/AllWidgets/noDriverAvailableDialog.dart';
import 'package:tnrapp/Models/placeDescription.dart';
import 'package:tnrapp/app_icons.dart';
import 'package:tnrapp/configMaps.dart';
import 'package:tnrapp/main.dart';
import 'package:tnrapp/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
/*
class MainScreen extends StatefulWidget {
  static const String idScreen = "mainscreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DirectionDetails tripDirectionDetails;

  bool _isLoggedIn = true;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference rideRequestRef;

  User user;

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  List<PlaceDescriptions> placePredictionList = [];

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  /*double rideDetailsContainer = 0;
  double searchContainerHeight = 0;
  double driverDetailsContainer = 0;
  double modeOfTransportContainer = 140.0;
  double googleMapTopPadding = 140.0;
  double routeContainer = 0;
  double rideBookContainer = 0;
  double inputDropOffContainer = 0;
  double bookButton = 0;
  double pickUpDestContainer = 0;
  double navButton = 30;*/

  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double searchContainerHeight = 300.0;
  double driverDetailsContainerHeight = 0;

  bool drawerOpen = true;
  bool nearbyAvailableDriverKeysLoaded = false;

  BitmapDescriptor nearByIcon;

  List<NearbyAvailableDrivers> availableDrivers;

  String state = "normal";

  StreamSubscription<Event> rideStreamSubscription;

  bool isRequestingPositionDetails = false;

  String uName = "";

  @override
  void initState() {
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
    _auth.userChanges().listen((event) => setState(() => user = event));
    //super.initState();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your address :" + address);

    initGeoFireListner();

    uName = user.displayName;

    AssistantMethods.retrieveHistoryInfo(context);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(16.617799081393763, 120.3280438126409),
    zoom: 14.4746,
  );

  void saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.reference().child("Ride Requests").push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var destination =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };
    Map destinationMap = {
      "latitude": destination.latitude.toString(),
      "longitude": destination.longitude.toString(),
    };
    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpMap,
      "dropOff": destinationMap,
      "created_at": DateTime.now().toString(),
      "commuter_name": user.displayName,
      "commuter_contactNum": user.phoneNumber,
      "pickup_address": pickUp.placeName,
      "destination_address": destination.placeName,
      "ride_type": carRideType,
    };

    rideRequestRef.set(rideInfoMap);

    rideStreamSubscription = rideRequestRef.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      }

      if (event.snapshot.value["car_details"] != null) {
        setState(() {
          carDetailsDriver = event.snapshot.value["car_details"].toString();
        });
      }
      if (event.snapshot.value["driver_name"] != null) {
        setState(() {
          driverName = event.snapshot.value["driver_name"].toString();
        });
      }
      if (event.snapshot.value["driver_phone"] != null) {
        setState(() {
          driverphone = event.snapshot.value["driver_phone"].toString();
        });
      }

      if (event.snapshot.value["driver_location"] != null) {
        double driverLat = double.parse(
            event.snapshot.value["driver_location"]["latitude"].toString());
        double driverLng = double.parse(
            event.snapshot.value["driver_location"]["longitude"].toString());
        LatLng driverCurrentLocation = LatLng(driverLat, driverLng);

        if (statusRide == "accepted") {
          updateRideTimeToPickUpLoc(driverCurrentLocation);
        } else if (statusRide == "onride") {
          updateRideTimeToDropOffLoc(driverCurrentLocation);
        } else if (statusRide == "arrived") {
          setState(() {
            rideStatus = "Driver has Arrived.";
          });
        }
      }

      if (event.snapshot.value["status"] != null) {
        statusRide = event.snapshot.value["status"].toString();
      }
      if (statusRide == "accepted") {
        displayDriverDetailsContainer();
        Geofire.stopListener();
        deleteGeofileMarkers();
      }
      if (statusRide == "ended") {
        if (event.snapshot.value["fares"] != null) {
          int fare = int.parse(event.snapshot.value["fares"].toString());
          var res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CollectFareDialog(
              paymentMethod: "cash",
              fareAmount: fare,
            ),
          );

          String driverId = "";
          if (res == "close") {
            if (event.snapshot.value["driver_id"] != null) {
              driverId = event.snapshot.value["driver_id"].toString();
            }

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RatingScreen(driverId: driverId)));

            rideRequestRef.onDisconnect();
            rideRequestRef = null;
            rideStreamSubscription.cancel();
            rideStreamSubscription = null;
            resetApp();
          }
        }
      }
    });
  }

  void deleteGeofileMarkers() {
    setState(() {
      markerSet
          .removeWhere((element) => element.markerId.value.contains("driver"));
    });
  }

  void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var positionUserLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      var details = await AssistantMethods.getPlaceDirectionDetails(
          driverCurrentLocation, positionUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Driver is Coming - " + details.durationText;
      });

      isRequestingPositionDetails = false;
    }
  }

  void updateRideTimeToDropOffLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var dropOff =
          Provider.of<AppData>(context, listen: false).dropOffLocation;
      var dropOffUserLatLng = LatLng(dropOff.latitude, dropOff.longitude);

      var details = await AssistantMethods.getPlaceDirectionDetails(
          driverCurrentLocation, dropOffUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Going to Destination - " + details.durationText;
      });

      isRequestingPositionDetails = false;
    }
  }

  void cancelRideRequest() {
    rideRequestRef.remove();
    setState(() {
      state = "normal";
    });
  }

  void displayDriverDetailsContainer() {
    setState(() {
      requestRideContainerHeight = 0.0;
      rideDetailsContainerHeight = 0.0;
      bottomPaddingOfMap = 295.0;
      driverDetailsContainerHeight = 285.0;
    });
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 300.0;
      bottomPaddingOfMap = 300.0;
      drawerOpen = false;
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 200.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 200.0;
      drawerOpen = true;
    });

    saveRideRequest();
  }

  resetApp() {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230.0;

      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();

      statusRide = "";
      driverName = "";
      driverphone = "";
      carDetailsDriver = "";
      rideStatus = "Driver is Coming";
      driverDetailsContainerHeight = 0.0;
    });

    locatePosition();
  }

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;
    var finalPosition =
        Provider.of<AppData>(context, listen: false).dropOffLocation;
    dropOffTextEditingController.text = finalPosition?.placeName;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TRACK",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Container(
        //side navigation contents
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              _isLoggedIn //if user is logged in show this container
                  ? Container(
                      height: 165.0,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            (user.photoURL == null)
                                ? Image.asset(
                                    'images/user_icon.png',
                                    height: 65.0,
                                    width: 65.0,
                                  )
                                : Image.network(
                                    user.photoURL,
                                    height: 65.0,
                                    width: 65.0,
                                  ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                user.displayName != null
                                    ? Text(user.displayName,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ))
                                    : Text(userCurrentInfo.name,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        )),
                                GestureDetector(
                                  onTap: () {
                                    //push to  Main Screen / this Home page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen()));
                                  },
                                  child: Text(
                                    "View Profile",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Roboto-Bold"),
                                  ),
                                ),
                                SizedBox(
                                  height: 6.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : DividerWidget(),
              SizedBox(
                height: 12.0,
              ),
              GestureDetector(
                onTap: () {
                  //push to  Main Screen / this Home page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home",
                      style: TextStyle(
                        fontSize: 15.0,
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //push to  Rides page
                },
                child: ListTile(
                  leading: Icon(Icons.drive_eta),
                  title: Text(
                    "Rides",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //push to  Chat page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatPage()));
                },
                child: ListTile(
                  leading: Icon(Icons.message),
                  title: Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //push to  About page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutScreen()));
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    "About",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //push to  About page
                  _googleSignIn.signOut().then((value) {
                    setState(() {
                      _isLoggedIn = false;
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    });
                  }).catchError((e) {});
                },
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap, top: 25.0),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markerSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
          ),

          //HamburgerButton for Drawer
          Positioned(
            top: 36.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if (drawerOpen) {
                  scaffoldKey.currentState.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drawerOpen) ? Icons.menu : Icons.close,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          //Search Ui
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.0),
                      Text(
                        "Hi there,",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        "Where to?",
                        style:
                            TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));

                          if (res == "obtainDirection") {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text("Search Destination"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickUpLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickUpLocation
                                        .placeName
                                    : "Add Home",
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Current home address",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      DividerWidget(),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work"),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Current Office Address",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Ride Details Ui
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      //bike ride
                      GestureDetector(
                        onTap: () {
                          displayToastMessage("Searching Taxi...", context);

                          setState(() {
                            state = "requesting";
                            carRideType = "Taxi";
                          });
                          displayRequestRideContainer();
                          availableDrivers =
                              GeoFireAssistant.nearByAvailableDriversList;
                          searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.taxi,
                                  color: Colors.black,
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Taxi",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand Bold",
                                      ),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null)
                                          ? tripDirectionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((tripDirectionDetails != null)
                                      ? 'P${(AssistantMethods.calculateFares(tripDirectionDetails)) * 35}'
                                      : ''),
                                  style: TextStyle(
                                    fontFamily: "Brand Bold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        height: 2.0,
                        thickness: 2.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      //tricyle ride
                      GestureDetector(
                        onTap: () {
                          displayToastMessage("searching Tricycle...", context);

                          setState(() {
                            state = "requesting";
                            carRideType = "Tricycle";
                          });
                          displayRequestRideContainer();
                          availableDrivers =
                              GeoFireAssistant.nearByAvailableDriversList;
                          searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.motorcycle,
                                  color: Colors.black,
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tricycle",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand Bold",
                                      ),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null)
                                          ? tripDirectionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((tripDirectionDetails != null)
                                      ? 'P${AssistantMethods.calculateFares(tripDirectionDetails) * 20}'
                                      : ''),
                                  style: TextStyle(
                                    fontFamily: "Brand Bold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        height: 2.0,
                        thickness: 2.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      //jeep ride
                      GestureDetector(
                        onTap: () {
                          displayToastMessage("searching Jeep...", context);

                          setState(() {
                            state = "requesting";
                            carRideType = "Jeep";
                          });
                          displayRequestRideContainer();
                          availableDrivers =
                              GeoFireAssistant.nearByAvailableDriversList;
                          searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  MyFlutterApp.jeep,
                                  color: Colors.black,
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Jeep",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand Bold",
                                      ),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null)
                                          ? tripDirectionDetails.distanceText
                                          : ''),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((tripDirectionDetails != null)
                                      ? 'P${(AssistantMethods.calculateFares(tripDirectionDetails)) * 9}'
                                      : ''),
                                  style: TextStyle(
                                    fontFamily: "Brand Bold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        height: 2.0,
                        thickness: 2.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyCheckAlt,
                              size: 18.0,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text("Cash"),
                            SizedBox(
                              width: 6.0,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black54,
                              size: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Cancel Ui
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: requestRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Center(
                            child: Column(
                          children: [
                            Text(
                              'Requesting for a ride...',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ],
                        ))),
                    SizedBox(
                      height: 22.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        cancelRideRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.0),
                          border:
                              Border.all(width: 2.0, color: Colors.grey[300]),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 26.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Cancel Ride",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Display Assisned Driver Info
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: driverDetailsContainerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rideStatus,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "Brand Bold"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Divider(
                      height: 2.0,
                      thickness: 2.0,
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Text(
                      carDetailsDriver,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      driverName,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Divider(
                      height: 2.0,
                      thickness: 2.0,
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //call button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(24.0),
                            ),
                            onPressed: () async {
                              launch(('tel://${driverphone}'));
                            },
                            color: Colors.black87,
                            child: Padding(
                              padding: EdgeInsets.all(17.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Call Driver   ",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  Future<void> getPlaceDirection() async {
    var initialPosition =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPosition =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatlng =
        LatLng(initialPosition.latitude, initialPosition.longitude);
    var dropOffLatlng = LatLng(finalPosition.latitude, finalPosition.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait...",
            ));

    var details = await AssistantMethods.getPlaceDirectionDetails(
        pickUpLatlng, dropOffLatlng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    print("This is encoded points: ");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodedPolylinePointsResult.isNotEmpty) {
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.orange,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatlng.latitude > dropOffLatlng.latitude &&
        pickUpLatlng.longitude > dropOffLatlng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatlng, northeast: pickUpLatlng);
    } else if (pickUpLatlng.longitude > dropOffLatlng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatlng.latitude, dropOffLatlng.longitude),
          northeast: LatLng(dropOffLatlng.latitude, pickUpLatlng.longitude));
    } else if (pickUpLatlng.latitude > dropOffLatlng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatlng.latitude, pickUpLatlng.longitude),
          northeast: LatLng(pickUpLatlng.latitude, dropOffLatlng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatlng, northeast: dropOffLatlng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow:
          InfoWindow(title: initialPosition.placeName, snippet: "My Location"),
      position: pickUpLatlng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow:
          InfoWindow(title: finalPosition.placeName, snippet: "Destination"),
      position: dropOffLatlng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpCircle = Circle(
      fillColor: Colors.blue,
      center: pickUpLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffCircle = Circle(
      fillColor: Colors.red,
      center: dropOffLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpCircle);
      circleSet.add(dropOffCircle);
    });
  }

  void initGeoFireListner() {
    Geofire.initialize("availableDrivers");
    //comment
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 15)
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableDriversList
                .add(nearbyAvailableDrivers);
            if (nearbyAvailableDriverKeysLoaded == true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
    //comment
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for (NearbyAvailableDrivers driver
        in GeoFireAssistant.nearByAvailableDriversList) {
      LatLng driverAvaiablePosition = LatLng(driver.latitude, driver.longitude);

      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverAvaiablePosition,
        //icon: nearByIcon,
        icon: BitmapDescriptor.defaultMarker,
        //rotation: AssistantMethods.createRandomNumber(360),
      );

      tMakers.add(marker);
    }
    setState(() {
      markerSet = tMakers;
    });
  }

  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog());
  }

  void searchNearestDriver() {
    if (availableDrivers.length == 0) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = availableDrivers[0];

    driversRef
        .child(driver.key)
        .child("car_details")
        .child("type")
        .once()
        .then((DataSnapshot snap) async {
      if (await snap.value != null) {
        String carType = snap.value.toString();
        if (carType == carRideType) {
          notifyDriver(driver);
          availableDrivers.removeAt(0);
        } else {
          displayToastMessage(
              carRideType + " drivers not available. Try again.", context);
        }
      } else {
        displayToastMessage("No car found. Try again.", context);
      }
    });
  }

  void notifyDriver(NearbyAvailableDrivers driver) {
    driversRef.child(driver.key).child("newRide").set(rideRequestRef.key);

    driversRef
        .child(driver.key)
        .child("token")
        .once()
        .then((DataSnapshot snap) {
      if (snap.value != null) {
        String token = snap.value.toString();
        AssistantMethods.sendNotificationToDriver(
            token, context, rideRequestRef.key);
      } else {
        return;
      }

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if (state != "requesting") {
          driversRef.child(driver.key).child("newRide").set("cancelled");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();
        }

        driverRequestTimeOut = driverRequestTimeOut - 1;

        driversRef.child(driver.key).child("newRide").onValue.listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.key).child("newRide").onDisconnect();
            driverRequestTimeOut = 40;
            timer.cancel();
          }
        });

        if (driverRequestTimeOut == 0) {
          driversRef.child(driver.key).child("newRide").set("timeout");
          driversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();

          searchNearestDriver();
        }
      });
    });
  }
}

class PredictonTile extends StatelessWidget {
  final PlaceDescriptions placeDescriptions;
  PredictonTile({Key key, this.placeDescriptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placeDescriptions.place_id, context);
        /*showProgressDialog();
          Future.delayed(Duration(seconds: 4), () {
            dismissProgressDialog();
          });*/
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placeDescriptions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placeDescriptions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 14.0,
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              message: 'Please wait...',
            ));

    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(Uri.parse(placeDetailsUrl));

    //Navigator.pop(context);

    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print("This is your drop off location: ");
      print(address.placeName);

      //Navigator.pop(context, "obtainDirection");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }
}

class CustomButton extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Icon icon;

  final String label;
  final Function() onPressed;
  const CustomButton({
    Key key,
    this.primaryColor,
    this.secondaryColor,
    this.icon,
    @required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        highlightElevation: 0.0,
        splashColor: secondaryColor,
        highlightColor: primaryColor,
        elevation: 0.0,
        color: primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16.0),
            side: BorderSide(color: Colors.black, width: 2)),
        child: Column(
          // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 14),
            )
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
*/