import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tnrapp/AllScreens/CameraAuth.dart';
import 'package:tnrapp/Assistants/assistantMethods.dart';

import '../configMaps.dart';

class DriverProfileScreen extends StatefulWidget {
  @override
  _DriverProfileScreenState createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoggedIn = true;
  //bool _isNotLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();

    AssistantMethods.getCurrentOnlineDriverUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.push(context,
              //MaterialPageRoute(builder: (context) => EditProfile()));
        },
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.edit,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
              )),
        ),
      ),
      body: _isLoggedIn
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                          /*
                          Text(
                            "Profile Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          */
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, bottom: 2),
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue[700],
                            ),
                            child: Row(
                              children: <Widget>[
                                /*Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),*/
                                SizedBox(
                                  width: 2,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraAuthScreen()));
                                  },
                                  child: 
                                    Text("Verify Account", 
                                      style: TextStyle(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.bold),)
                                  ),
                                
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16,),
                    child: Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(15)),
                          gradient: RadialGradient(
                            colors: [Colors.blue[100], Colors.blue[400]],
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          firebaseUser.displayName != null ? Text('Hi, '+ user.displayName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              )) :
                          Text('Hi, '+ driverUserCurrentInfo.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          firebaseUser.photoURL != null ? CircleAvatar(
                            radius: 65.0,
                            backgroundImage: NetworkImage(
                              user.photoURL,
                            ),
                            backgroundColor: Colors.white,
                          )
                          : Image.asset('images/user_icon.png', height: 65.0, width: 65.0,),
                          SizedBox(
                            height: 10.0,
                          ),
                          
                          Text(
                            'Driver',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16, bottom: 16,
                    ),
                    child: Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.grey[200],
                        child: Center(
                            child: Card(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                                child: Container(
                                    width: 310.0,
                                    height: 230.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Personal Information",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.home,
                                                color: Colors.blueAccent[400],
                                                size: 35,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Home Address",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    "No address added",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[400],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: Colors.orange[400],
                                                size: 35,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Contact Number",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  driverUserCurrentInfo.contactNum != null ? Text(
                                                    driverUserCurrentInfo.contactNum,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ) :
                                                  Text(
                                                    "No contact number",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: Colors.pinkAccent[400],
                                                size: 35,
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Email Address",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  firebaseUser.email != null ? Text(
                                                    user.email,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ) :
                                                  Text(
                                                    driverUserCurrentInfo.email,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )))),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 10.0,
            ),
    );
  }


}
