import 'package:flutter/material.dart';

class VehicleMgmtScreen extends StatefulWidget {
  @override
  _VehicleMgmtScreenState createState() => _VehicleMgmtScreenState();
}

class _VehicleMgmtScreenState extends State<VehicleMgmtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle Management')),
      body: vehicleMgmt(),
    );
  }

  Widget vehicleMgmt() {
    return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, bottom: 2),
                            height: 32,
                            child: Row(
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                  },
                                  child: 
                                    Text("Add", 
                                      style: TextStyle(fontSize: 14.0,color: Colors.pink,fontWeight: FontWeight.bold),)
                                  ),
                                Icon(
                                  Icons.add,
                                  color: Colors.pink,
                                  size: 20,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 50,
                    right: 50,
                    child: Padding(
                      padding:EdgeInsets.all(16.0),
                      child: Container(
                        padding:EdgeInsets.all(12.0),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding:EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.orange[400],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Icon(Icons.drive_eta, size: 50, color: Colors.white,)),
                            Container(
                              child: Column(
                                children: [
                                  Text('Car 1', style: TextStyle(
                                      fontSize: 25.0, fontWeight: FontWeight.bold,
                                    ),),
                                  SizedBox(height: 5,),
                                  Text('data', style: TextStyle(
                                      fontSize: 15.0,
                                    ),),
                                ],
                              ),
                            ),
                            SizedBox(width: 20,),
                            Container(child: Icon(Icons.check_circle_rounded, size: 20,))
                          ],
                          ),
                      ),
                    ),
                  ),
                ]
              )
            );
  }
}