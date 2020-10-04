import 'package:cloud_firestore/cloud_firestore.dart';

class Student {

  String uid;
  String avatarUrl;
  String email;
  String gradeId;
  String name;
  String schoolId;
  bool   state;
  String token;
  String gradeName;
  int totalPoints;

  Student.fromDocumentSnapshot(DocumentSnapshot data) {
    this.uid = data.documentID;
    this.avatarUrl = data["avatar_url"];
    this.email = data["email"];
    this.gradeId = data["grade_id"];
    this.name = data["name"];
    this.schoolId = data["school_id"];
    this.state = data["state"];
    this.token = data["token"];
    this.totalPoints = 1350;
  }
}