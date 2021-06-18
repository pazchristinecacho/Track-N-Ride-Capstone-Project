import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tnrapp/AllScreens/login.dart';
import 'package:tnrapp/AllScreens/searchScreen.dart';
import 'package:tnrapp/AllWidgets/Divider.dart';
import 'package:tnrapp/Assistants/assistantMethods.dart';
import 'package:tnrapp/Assistants/requestAssistant.dart';
import 'package:tnrapp/CommuterScreen/ChatPage.dart';
import 'package:tnrapp/CommuterScreen/Profile.dart';
import 'package:tnrapp/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tnrapp/Models/address.dart';
import 'package:tnrapp/Models/directionDetails.dart';
import 'package:tnrapp/Models/placeDescription.dart';
import 'package:tnrapp/app_icons.dart';
import 'package:tnrapp/configMaps.dart';

class MainScreen extends StatefulWidget {
  // This widget is the root of your application.
  static const String idScreen = "mainscreen";
  //final String returnContext;
  //const MyRecord(this.returnContext);
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
  //bool _isNotLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Position _currentPosition;
  String _currentAddress;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  List<PlaceDescriptions> placePredictionList = [];

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  double rideDetailsContainer = 0;
  double searchContainerHeight = 0;
  double modeOfTransportContainer = 140.0;
  double googleMapTopPadding = 140.0;
  double routeContainer = 0;
  double rideBookContainer = 0;
  double inputDropOffContainer = 0;
  double bookButton = 0;
  double pickUpDestContainer = 0;

  bool drawerOpen = true;

  /*resetApp(){
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 0;
      rideDetailsContainer = 0.0;
      bottomPaddingOfMap = 0.0;
      modeOfTransportContainer = 140.0;
      googleMapTopPadding = 140.0;
      rideBookContainer = 0;
      bookButton = 0;
      inputDropOffContainer = 0;
      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();
      
    });
    locatePosition();
  }*/

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainer = 200.0;
      bottomPaddingOfMap = 200.0;
      rideBookContainer = 0;
      inputDropOffContainer = 0;
      drawerOpen = false;
    });
  }

  void bookButtonContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      bookButton = 100;
      googleMapTopPadding = 0;
      rideDetailsContainer = 0.0;
      bottomPaddingOfMap = 0.0;
      rideBookContainer = 50;
      inputDropOffContainer = 0;
      pickUpDestContainer = 250;
    });
  }

  void displayRouteContainer() async {
    setState(() {
      googleMapTopPadding = 160;
      modeOfTransportContainer = 0;
      //bottomPaddingOfMap = 200.0;
      rideBookContainer = 50;
      inputDropOffContainer = MediaQuery.of(context).size.height;
    });
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
    //String address = await AssistantMethods.searchCoordinateAddress(position);
    //String address = await AssistantMethods.searchCoordinateAddress(position);
    print("This is your address :" + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(16.617799081393763, 120.3280438126409),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;
    var finalPosition = Provider.of<AppData>(context, listen: false).dropOffLocation;
    dropOffTextEditingController.text = finalPosition.placeName;

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
                            //if(Image.network(user.photoURL) != null)
                            Image.network(
                              //photo of google user
                              user.photoURL,
                              height: 65.0,
                              width: 65.0,
                            ),
                            //if(Image.network(user.photoURL) == null)
                            //Image.asset('images/user_icon.png', height: 65.0, width: 65.0,),
                            SizedBox(
                              width: 16.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text(user.displayName, style: TextStyle(fontSize: 12.0, fontFamily: "Roboto-Bold"), textAlign: TextAlign.left,),
                                TextButton(
                                  onPressed: () {
                                    //push to Profile Details Screen
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
                                //Text(user.email, style: TextStyle(fontSize: 10.0, fontFamily: "Roboto-Bold"),),
                                //Text("View Profile", style: TextStyle(fontSize: 16.0, fontFamily: "Roboto-Bold"),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  :
                  /*_isNotLoggedIn ? Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white,),
                  child: Row(
                    children: [
                      Image.asset('images/user_icon.png', height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Profile Name", style: TextStyle(fontSize: 16.0, fontFamily: "Roboto-Bold"),),
                          SizedBox(height: 6.0,),
                          Text("View Profile", style: TextStyle(fontSize: 16.0, fontFamily: "Roboto-Bold"),),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              :*/

                  DividerWidget(),
              SizedBox(
                height: 12.0,
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: TextButton(
                    onPressed: () {
                      //push to  Main Screen / this Home page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ),
              ListTile(
                leading: Icon(Icons.drive_eta),
                title: Text(
                  "Ride History",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: TextButton(
                    onPressed: () {
                      //push to Chat Page
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatPage()));
                    },
                    child: Text(
                      "Messages",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "About",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: TextButton(
                    onPressed: () {
                      //log out user, push to Login Screen
                      _googleSignIn.signOut().then((value) {
                        setState(() {
                          _isLoggedIn = false;
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.idScreen, (route) => false);
                        });
                      }).catchError((e) {});
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            //map api
            padding: EdgeInsets.only(
              top: googleMapTopPadding,
            ),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            compassEnabled: true,
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
                bottomPaddingOfMap = 50.0;
              });
              locatePosition(); //locate current position method
            },
          ),

          //navigation hamburger button
          Positioned(
            top: 30.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if(drawerOpen){
                  scaffoldKey.currentState.openDrawer();
                }
                else{
                  //resetApp();
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
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          

          //widget for mode of transport container
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: modeOfTransportContainer,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Text(
                      "Mode of Transportation",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                    Divider(),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: GestureDetector(
                                onTap: () {
                                  print("clicked Taxi");
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          titlePadding: const EdgeInsets.all(0),
                                          title: Stack(
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 10, 5, 10),
                                                  color: Colors.orangeAccent,
                                                  child: Center(
                                                      child: Column(
                                                    children: [
                                                      Text('Taxi'),
                                                    ],
                                                  ))),
                                            ],
                                          ),
                                          actions: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              child: Center(
                                                child: Padding(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomButton(
                                                        label: "Book",
                                                        primaryColor:
                                                            Colors.white,
                                                        secondaryColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                      ),
                                                      SizedBox(height: 20),
                                                      CustomButton(
                                                        label: "Route Explorer",
                                                        primaryColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        secondaryColor:
                                                            Colors.white,
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 20, right: 15),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }).then((exit) {
                                    if (exit == null) return;

                                    if (exit) {
                                      // user pressed Book button
                                      displayRouteContainer();
                                    } else {
                                      // user pressed Route Explorer button

                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Icon(
                                      FontAwesomeIcons.taxi,
                                      color: Colors.black,
                                      size: 18.0,
                                    ),
                                    radius: 30.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: GestureDetector(
                                onTap: () {
                                  print("clicked Tric");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Icon(
                                      FontAwesomeIcons.motorcycle,
                                      color: Colors.black,
                                      size: 18.0,
                                    ),
                                    radius: 30.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: GestureDetector(
                                onTap: () {
                                  print("clicked jeep");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Icon(
                                      MyFlutterApp.jeep,
                                      color: Colors.black,
                                      size: 18.0,
                                    ),
                                    radius: 30.0,
                                  ),
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
            ),
          ),

          //book a taxi top container (ridebookCont)
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: rideBookContainer,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Text(
                      "Book a Taxi",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //pick up and search destination container; where clicking the search will push to searchscreen
          Positioned(
            top: 40.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              height: inputDropOffContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
            

            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
              child: Column(
                children: [

                  SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            style: TextStyle(fontSize: 12.0,),
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: 'Pick Up Location',
                              fillColor: Colors.white,
                              hintStyle: TextStyle(fontSize: 15.0,),
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()));

                                if (res == "obtainDirection") {
                                  //await getPlaceDirection();
                                  //displayRideDetailsContainer();
                                  bookButtonContainer();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.2,
                                      offset: Offset(0.1, 0.1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text("Search Destination"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /*TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              style: TextStyle(color: Colors.black),
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Search Destination",
                                hintStyle: TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),*/
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          SizedBox(height: 2.0,),
          (placePredictionList.length > 0)
          ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0,),
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index){
                  return PredictonTile(placeDescriptions: placePredictionList[index],);
                }, 
                separatorBuilder: (BuildContext context, int index) => DividerWidget(), 
                itemCount: placePredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ),
          )
          : Container(),
                  ],
                ),
              ),
              
            ),
          ),

          //pick up and destination location container
          Positioned(
            top: 40.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              height: pickUpDestContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
            

            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
              child: Column(
                children: [

                  SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            style: TextStyle(fontSize: 12.0,),
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: 'Pick Up Location',
                              fillColor: Colors.white,
                              hintStyle: TextStyle(fontSize: 15.0,),
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              style: TextStyle(fontSize: 12.0, color: Colors.black),
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Search Destination",
                                hintStyle: TextStyle(color: Colors.black,),
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
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
                  ],
                ),
              ),
              
            ),
          ),
          
          //search destination only container
          Positioned(
            top: 60.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              height: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                              onTap: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen()));

                                if (res == "obtainDirection") {
                                  //await getPlaceDirection();
                                  //displayRideDetailsContainer();
                                  bookButtonContainer();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.2,
                                      offset: Offset(0.1, 0.1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text("Search Destination"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  ],
                ),
              ),
            ),
          ),

          //book button container
          Positioned(
            bottom: 20.0,
            right: 0.0,
            child: Container(
              height: bookButton,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical:10.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                              onTap: () async {
                                showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          titlePadding: const EdgeInsets.all(0),
                                          title: Stack(
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 10, 5, 10),
                                                  color: Colors.orangeAccent,
                                                  child: Center(
                                                      child: Column(
                                                    children: [
                                                      Text('We\ve found 1 driver/s for you', style: TextStyle(color: Colors.white, fontSize: 12.0),),
                                                    ],
                                                  ))),
                                            ],
                                          ),
                                          actions: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              child: Center(
                                                child: Padding(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomButton(
                                                        label: "Book Now",
                                                        primaryColor:
                                                            Colors.white,
                                                        secondaryColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                      ),
                                                      SizedBox(height: 20),
                                                      CustomButton(
                                                        label: "Route Explorer",
                                                        primaryColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        secondaryColor:
                                                            Colors.white,
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 20, right: 15),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }).then((exit) {
                                    if (exit == null) return;

                                    if (exit) {
                                      // user pressed Book button
                                      displayRideDetailsContainer();
                                    } else {
                                      // user pressed Route Explorer button

                                    }
                                  });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.2,
                                      offset: Offset(0.1, 0.1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text("Book", style: TextStyle(color: Colors.white)),
                                      Icon(
                                        Icons.arrow_right_alt,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  ],
                ),
              ),
            ),
          ),

          //widget for ride request details
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainer,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.amberAccent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/taxi.png",
                                height: 70.0,
                                width: 80.0,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Car",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Roboto-Bold"),
                                  ),
                                  Text(
                                    ((tripDirectionDetails != null) 
                                    ?  tripDirectionDetails.distanceText : ''),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                    ((tripDirectionDetails != null) 
                                    ?  '\$${AssistantMethods.calculateDistance(tripDirectionDetails)}' : ''),
                                    style: TextStyle(
                                        fontSize: 16.0, fontFamily: "Roboto-Bold"),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //widget for destination input
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
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 14.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        "Hi there, ",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        "Where to? ",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: "Roboto-Bold"),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));

                          if (res == "obtainDirection") {
                            //await getPlaceDirection();
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
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
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text("Search Drop-off"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
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
                                        ?.placeName
                                    : 'Add Home',
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Your living home address",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 16.0,
                      ),
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
                              Text('Add Work'),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Your office address",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange[400],
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta_outlined),
            title: Text("Rides"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            title: Text("Chats"),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }

    void findPlace(String placeName) async{
    if(placeName.length > 1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ph";

      var res = await RequestAssistant.getRequest(Uri.parse(autoCompleteUrl));

      if(res == "failed"){
        return;
      }
      //print("Places Predictions Response :: ");
      //print(res);
      if(res["status"] == "OK"){
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => PlaceDescriptions.fromJson(e)).toList();
        setState(() {
                  placePredictionList = placesList;
          });
      }
    }
  }

  Future<void> getPlaceDirection() async {
    var initialPosition =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPosition =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatlng =
        LatLng(initialPosition.latitude, initialPosition.longitude);
    var dropOffLatlng = LatLng(finalPosition.latitude, finalPosition.longitude);

    /*
    showDialog(
      context: context, 
      builder: (BuildContext context) => showProgressDialog(message: "Setting Dropoff, please wait...",)
    );
    */

    var details = await AssistantMethods.getPlaceDirectionDetails(pickUpLatlng, dropOffLatlng);

    setState(() {
          tripDirectionDetails = details;
        });

    //Navigator.pop(context);

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
      infoWindow: InfoWindow(
          title: finalPosition.placeName, snippet: "Destination"),
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

  void routeDisplay() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            titlePadding: const EdgeInsets.all(0),
            title: Stack(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.orangeAccent,
                    child: Center(
                        child: Column(
                      children: [
                        Text('Taxi'),
                      ],
                    ))),
              ],
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // background
                        onPrimary: Colors.orangeAccent, // foreground
                        side: BorderSide(color: Colors.black, width: 2),
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Book',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    RaisedButton(
                        padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
                        onPressed: () {},
                        color: Colors.orangeAccent, // background
                        textColor: Colors.white, // foreground
                        child: Text('Route Explorer'),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }


}

class PredictonTile extends StatelessWidget {

  final PlaceDescriptions placeDescriptions;
  PredictonTile({ Key key, this.placeDescriptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getPlaceAddressDetails(placeDescriptions.place_id, context);
        /*showProgressDialog();
          Future.delayed(Duration(seconds: 4), () {
            dismissProgressDialog();
          });*/
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0,),
                      Text(placeDescriptions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.0),),
                      SizedBox(height: 8.0,),
                      Text(placeDescriptions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 14.0,),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    /*
    showDialog(
      context: context, 
      builder: (BuildContext context) => showProgressDialog(message: "Setting Dropoff, please wait...",)
    );
    */

    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(Uri.parse(placeDetailsUrl));

    //Navigator.pop(context);

    if(res == "failed"){
      return;
    }
    if(res["status"] == "OK"){
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("This is your drop off location: ");
      print(address.placeName);



      //Navigator.pop(context, "obtainDirection");
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
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


