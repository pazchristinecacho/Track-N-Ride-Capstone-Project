import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class driverUsers{
  String id;
  String name;
  String email;
  String contactNum;
  driverUsers({this.id, this.name,this.email,this.contactNum});

  driverUsers.fromSnapshot(DataSnapshot dataSnapshot){
    id = dataSnapshot.key;
    name = dataSnapshot.value["name"];
    email = dataSnapshot.value["email"];
    contactNum = dataSnapshot.value["phone"];
  }
}