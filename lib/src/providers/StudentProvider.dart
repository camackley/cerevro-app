import 'dart:async';

import 'package:cerevro_app/src/models/Student.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class StudentProvider{

  final _studentStream = StreamController<Student>.broadcast();

  Function(Student) get studentSink => _studentStream.sink.add;
  Stream<Student> get studentStream => _studentStream.stream;

  void disposeStream(){
    _studentStream?.close();
  }

  getCurrentStudent(){
     FirebaseAuth.instance
        .currentUser()
        .then((currentStudent) {
          Firestore.instance
            .collection("students")
            .document(currentStudent.uid)
            .snapshots()
            .listen((data) {
              Student student = Student.fromDocumentSnapshot(data);
              studentSink(student);
            });
        });
  }

}