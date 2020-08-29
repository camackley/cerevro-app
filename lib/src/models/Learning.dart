import 'package:cloud_firestore/cloud_firestore.dart';

class Learning {

  String uid;
  String experienceId;
  String miniature;
  String name;
  String summary;
  String url;
  int order;
  bool state;

  Learning.fromDocumentSnapshot(DocumentSnapshot data) {
    this.uid = data.documentID;
    this.experienceId = data["experience_id"];
    this.miniature = data["miniature"];
    this.name = data["name"];
    this.summary = data["summary"];
    this.url = data["url"];
    this.order = data["order"];
    this.state = data["state"];
  }

}