import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {

  bool      state;
  String    name;
  String    summary;
  String    miniature;
  String    duration;
  int       likes;
  int       views;
  Timestamp creationDate;

  Experience.fromJson(Map data) {
    this.state =data["state"];
    this.name =data["name"];
    this.summary =data["summary"];
    this.miniature =data["miniature"];
    this.duration =data["duration"];
    this.likes =data["likes"];
    this.views =data["views"];
    this.creationDate =data["creationDate"];
  }
}