import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tnrapp/AllScreens/loginScreenDriver.dart';
import 'package:tnrapp/AllScreens/searchScreen.dart';
import 'package:tnrapp/AllWidgets/Divider.dart';
import 'package:tnrapp/Assistants/assistantMethods.dart';
import 'package:tnrapp/Assistants/requestAssistant.dart';
import 'package:tnrapp/CommuterScreen/ChatPage.dart';
import 'package:tnrapp/CommuterScreen/Profile.dart';
import 'package:tnrapp/DataHandler/appData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tnrapp/DriverScreen/DriverProfile.dart';
import 'package:tnrapp/DriverScreen/VehicleSettingsScreen.dart';
import 'package:tnrapp/Models/address.dart';
import 'package:tnrapp/Models/directionDetails.dart';
import 'package:tnrapp/Models/placeDescription.dart';
import 'package:tnrapp/app_icons.dart';
import 'package:tnrapp/configMaps.dart';

class MainScreenDriver extends StatefulWidget {
  static const String idScreen = "mainscreenDriver";
  @override
  _MainScreenDriverState createState() => _MainScreenDriverState();
}

class _MainScreenDriverState extends State<MainScreenDriver> with TickerProviderStateMixin {
  
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
  double bottomPaddingOfMap = 250;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  List<PlaceDescriptions> placePredictionList = [];

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  double googleMapTopPadding = 200.0;
  double navButton = 20;

  bool drawerOpen = true;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your address :" + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(16.617799081393763, 120.3280438126409), zoom: 14.4746,
  );

  @override
  void initState() {
    AssistantMethods.getCurrentOnlineDriverUserInfo();
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  void rideRequest() {
  }

  void cancelRideRequest(){
    rideRequestRef.remove();
  }

  resetApp(){
    setState(() {
      drawerOpen = true;
      bottomPaddingOfMap = 0.0;
      googleMapTopPadding = 140.0;
      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();
      
    });
    locatePosition();
  }

  void displayRouteContainer() async {
    setState(() {
      googleMapTopPadding = 160;
      navButton = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;
    var finalPosition = Provider.of<AppData>(context, listen: false).dropOffLocation;
    dropOffTextEditingController.text = finalPosition?.placeName;


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("TRACK",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      drawer: Container( //side navigation contents
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              _isLoggedIn //if user is logged in show this container
                  ? Container(
                      height: 165.0,
                      child: DrawerHeader(
                        decoration: BoxDecoration(color: Colors.white,),
                        child: Row(
                          children: [
                            firebaseUser.photoURL != null ? 
                            Image.network(user.photoURL, height: 65.0, width: 65.0,) //photo of user
                            : Image.asset('images/user_icon.png', height: 65.0, width: 65.0,),
                            SizedBox(width: 16.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                firebaseUser.displayName != null ? Text(user.displayName,
                                  style: TextStyle(fontSize: 12.0,)
                                  ) :
                                Text(driverUserCurrentInfo.name,
                                  style: TextStyle(fontSize: 12.0,)
                                ),
                                GestureDetector(
                                  onTap: (){ //push to  Main Screen / this Home page
                                    Navigator.push(context, MaterialPageRoute( builder: (context) => DriverProfileScreen()));
                                  },
                                  child: Text(
                                    "View Profile",
                                    style: TextStyle(fontSize: 16.0, fontFamily: "Roboto-Bold"),
                                  ),
                                ),
                                SizedBox(height: 6.0,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  :

                  DividerWidget(),
                  SizedBox(height: 12.0,),
                  GestureDetector(
                    onTap: (){ //push to  Main Screen / this Home page
                      Navigator.push(context,MaterialPageRoute(builder: (context) => MainScreenDriver()));
                    },
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home", style: TextStyle(fontSize: 15.0,)),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){ //push to  Rides page
                      
                    },
                    child: ListTile(
                      leading: Icon(Icons.drive_eta),
                      title: Text(
                        "Rides", style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){ //push to  Chat page
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ChatPage()));
                    },
                    child: ListTile(
                      leading: Icon(Icons.message),
                      title: Text(
                            "Messages", style: TextStyle( fontSize: 15.0, ),
                          ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){ //push to  About page
                      Navigator.push(context,MaterialPageRoute(builder: (context) => VehicleMgmtScreen()));
                    },
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.cog),
                      title: Text( "Vehicle Management",
                        style: TextStyle(fontSize: 15.0),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){ //push to  About page
                      _googleSignIn.signOut().then((value) {
                        setState(() {
                          _isLoggedIn = false;
                          Navigator.pushNamedAndRemoveUntil(context, LoginScreenDriver.idScreen, (route) => false);
                        });
                      }).catchError((e) {});
                    },
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        "Logout",
                        style: TextStyle(fontSize: 15.0,),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap( //map api
            padding: EdgeInsets.only(top: googleMapTopPadding,),
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
                bottomPaddingOfMap = 200;
              });
              locatePosition(); //call locate current position method
            },
          ),

          //navigation hamburger button
          Positioned(
            top: navButton,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if(drawerOpen){
                  scaffoldKey.currentState.openDrawer();
                }
                else{
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
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          //search destination only container
          Positioned(
            top: 70.0,
            left: 25.0,
            right: 25.0,
            child: Container(
            height: 110.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              child: Column(
                children: [
                  Center(
                    child: Text("You are here", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      SizedBox(width: 5.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(0.2),
                          ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Pickup Location",
                              hintStyle: TextStyle(color: Colors.black, fontSize: 12),
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
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
            height: 160.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      firebaseUser.photoURL != null ? //if photoUrl of logged in user is not null
                      Image.network(user.photoURL, height: 30.0, width: 30.0,) //display photo of user
                      : Image.asset('images/user_icon.png', height: 30.0, width: 30.0,), //else display icon only
                      SizedBox(width: 5.0,),
                      driverUserCurrentInfo.name != null ?
                      Text(driverUserCurrentInfo.name,
                        style: TextStyle(fontSize: 20.0,)
                      )
                      : Text("Driver"),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Positioned(
                    bottom: 5,
                    left: 20.0,
                    right: 20.0,
                    child: Card(
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding:EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child:Column(
                                children: [
                                  Icon(Icons.drive_eta),
                                  Text('0',
                                  style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.bold,
                                  ),),
                                  Text('Total Rides',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0
                                  ),),
                                ],
                              )
                            ),

                            Container(
                              child: Column(
                              children: [
                                Icon(Icons.transfer_within_a_station),
                                Text('0',
                                  style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.bold,
                                ),),
                                Text('Requests',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0
                                ),),
                              ]),
                            ),

                            Container(
                                child:Column(
                                  children: [
                                    Icon(Icons.check_circle_outline),
                                  Text('0',
                                  style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.bold,
                                  ),),
                                  Text('Completed',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0
                                  ),),
                                  ],
                                )
                            ),
                          ],
                        ),
                      )
                    )
                )

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


