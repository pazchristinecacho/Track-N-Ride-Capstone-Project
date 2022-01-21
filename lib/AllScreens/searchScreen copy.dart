import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tnrapp/AllScreens/mainscreen.dart';
import 'package:tnrapp/AllWidgets/Divider.dart';
import 'package:tnrapp/Assistants/requestAssistant.dart';
import 'package:tnrapp/DataHandler/appData.dart';
import 'package:tnrapp/Models/address.dart';
import 'package:tnrapp/Models/placeDescription.dart';

import '../configMaps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  List<PlaceDescriptions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
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
              padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Icon(
                            Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Set Your Destination", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.0,),
                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Pickup Location",
                              hintStyle: TextStyle(color: Colors.black),
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

                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
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
          SizedBox(height: 10.0,),
          (placePredictionList.length > 0)
          ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0,),
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
          )
          : Container(),
        ],
      ),
    );
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
                      Text(placeDescriptions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
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

      Navigator.pop(context, "obtainDirection");
    }
    
  }
}

/*
Positioned(
            top: 160.0,
            left: 25.0,
            right: 25.0,
            child: Container(
                  height: searchDropDownContainer,
                  child: (placePredictionList.length > 0)
                  ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0,),
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
                  )
                  : Container(),
                ),
          ),

          child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.grey,),
                              SizedBox(height: 10.0,),
                              AutoSizeText.rich(
                                TextSpan(text: Provider.of<AppData>(context).pickUpLocation !=null
                                    ? Provider.of<AppData>(context).pickUpLocation?.placeName
                                    : 'Your current location',),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey,),
                      SizedBox(height: 10.0,),
                      TextField(
                        onChanged: (val){
                          //findPlace(val);
                        },
                        //controller: dropOffTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Set Drop Off",
                          fillColor: Colors.grey[400],
                          filled: true,
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ],
 */