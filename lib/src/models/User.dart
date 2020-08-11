import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  String avatarUrl;
  String emial;
  String gradeId;
  String name;
  String schoolId;
  bool   state;
  String token;

  User.fromDocumentSnapshot(DocumentSnapshot data) {
    this.avatarUrl = data["avatarUrl"];
    this.emial = data["emial"];
    this.gradeId = data["gradeId"];
    this.name = data["name"];
    this.schoolId = data["schoolId"];
    this.state = data["state"];
    this.token = data["token"];
  }
}