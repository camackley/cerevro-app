import 'package:cloud_firestore/cloud_firestore.dart';

class Student {

  String avatarUrl;
  String email;
  String gradeId;
  String name;
  String schoolId;
  bool   state;
  String token;

  Student.fromDocumentSnapshot(DocumentSnapshot data) {
    this.avatarUrl = data["avatar_url"];
    this.email = data["email"];
    this.gradeId = data["grade_id"];
    this.name = data["name"];
    this.schoolId = data["school_id"];
    this.state = data["state"];
    this.token = data["token"];
  }
}