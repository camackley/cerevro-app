import 'dart:async';
import 'package:cerevro_app/src/models/Experience.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cerevro_app/src/models/Learning.dart';
import 'package:cerevro_app/src/models/Student.dart';

class Provider{

  final _studentStream = StreamController<Student>.broadcast();

  Function(Student) get studentSink => _studentStream.sink.add;
  Stream<Student> get studentStream => _studentStream.stream;

  final _learningStream = StreamController<List<Learning>>.broadcast();

  Function(List<Learning>) get learningSink => _learningStream.sink.add;
  Stream<List<Learning>> get learningStream => _learningStream.stream;

  final _searcExperienceStream = StreamController<List<Experience>>.broadcast();

  Function(List<Experience>) get searchExperiencegSink => _searcExperienceStream.sink.add;
  Stream<List<Experience>> get searchExperienceStream => _searcExperienceStream.stream;

  /* Firebase Instance */
  var _firebaseintance = Firestore.instance; 

  void disposeStream(){
    _studentStream?.close();
    _learningStream?.close();
    _searcExperienceStream?.close();
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

  getLearnings(uid){
    List<Learning> learnings = new List<Learning>();
    Firestore.instance
      .collection("learnings")
      .where("experience_id", isEqualTo: uid)
      .orderBy("order")
      .snapshots()
      .listen((data) { 
        learnings.clear();
        for(var item in data.documents){
          Learning experience = new Learning.fromDocumentSnapshot(item);
          learnings.add(experience);
        }
        learningSink(learnings);
      });
  }

  getSearch(List<String> search){
    //TODO: Implementar filtros
    List<Experience> searchResult = new List<Experience>();
    if(search[0].length > 0){
      _firebaseintance
      .collection('experiences')
      .where("name_query", arrayContains: search[0])
      .snapshots()
      .listen((event) {
        searchResult.clear();
        for(DocumentSnapshot item in event.documents){
          Experience experience = new Experience.fromDocumentSnapshot(item);
          searchResult.add(experience);
        }
        searchExperiencegSink(searchResult);
      });
    }else{
      var firebaseQuery = _firebaseintance.collection('experiences');
      if(search[2] != null) firebaseQuery = firebaseQuery.where("principal_tag", isEqualTo: search[2]);
      if(search[1] !=null) firebaseQuery = firebaseQuery.orderBy(search[1]);
      
      firebaseQuery
      .limit(10)
      .snapshots()
      .listen((event) {
        searchResult.clear();
        for(DocumentSnapshot item in event.documents){
          Experience experience = new Experience.fromDocumentSnapshot(item);
          searchResult.add(experience);
        }
        searchExperiencegSink(searchResult);
      });
    }
  }
}