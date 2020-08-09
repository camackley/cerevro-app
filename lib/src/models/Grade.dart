import 'package:cloud_firestore/cloud_firestore.dart';

class Grade {

  String uid;
  String name;
  String schoolId;
  bool   state;

  Grade.fromJson(DocumentSnapshot data) {
    this.uid=data.documentID;
    this.name=data["name"];
    this.schoolId=data["school_id"];
    this.state=data["state"];
  }
}