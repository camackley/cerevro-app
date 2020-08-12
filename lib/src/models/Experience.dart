import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {

  String uid;
  bool      state;
  String    name;
  String    summary;
  String    miniature;
  String    duration;
  String    principalTag;
  int       likes;
  int       views;
  Timestamp creationDate;

  Experience.fromDocumentSnapshot(DocumentSnapshot data) {
    this.uid = data.documentID;
    this.state =data["state"];
    this.name =data["name"];
    this.summary =data["summary"];
    this.miniature =data["miniature"];
    this.duration =data["duration"];
    this.principalTag = data["principal_tag"];
    this.likes =data["likes"];
    this.creationDate = data["creation_date"];
    this.views =data["views"];
  }
}