import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class commuterUsers{
  String id;
  String name;
  String email;
  String contactNum;
  commuterUsers({this.id, this.name,this.email,this.contactNum});

  commuterUsers.fromSnapshot(DataSnapshot dataSnapshot){
    id = dataSnapshot.key;
    name = dataSnapshot.value["name"];
    email = dataSnapshot.value["email"];
    contactNum = dataSnapshot.value["phone"];
  }
}