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

  final _searchExperienceStream = StreamController<List<Experience>>.broadcast();

  Function(List<Experience>) get searchExperiencegSink => _searchExperienceStream.sink.add;
  Stream<List<Experience>> get searchExperienceStream => _searchExperienceStream.stream;

  final _historyExperienceStream = StreamController<List<ResumeExperience>>.broadcast();

  Function(List<ResumeExperience>) get historyExperiencegSink => _historyExperienceStream.sink.add;
  Stream<List<ResumeExperience>> get historyExperienceStream => _historyExperienceStream.stream;

  /* Firebase Instance */
  var _firebaseintance = Firestore.instance; 

  void disposeStream(){
    _studentStream?.close();
    _learningStream?.close();
    _searchExperienceStream?.close();
    _historyExperienceStream?.close();
  }

  getCurrentStudent(){
     FirebaseAuth.instance
        .currentUser()
        .then((currentStudent) {
          _firebaseintance
            .collection("students")
            .document(currentStudent.uid)
            .snapshots()
            .listen((data) {
              Student student = Student.fromDocumentSnapshot(data);
              _firebaseintance.collection("grade").document(student.gradeId).get().then((value){
                student.gradeName = value["name"];
                studentSink(student);
              });
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

  getSearch(List<String> searchh){
    //TODO: Implementar filtros
    List<Experience> searchhResult = new List<Experience>();
    if(searchh[0].length > 0){
      _firebaseintance
      .collection('experiences')
      .where("name_query", arrayContains: searchh[0])
      .snapshots()
      .listen((event) {
        searchhResult.clear();
        for(DocumentSnapshot item in event.documents){
          Experience experience = new Experience.fromDocumentSnapshot(item);
          searchhResult.add(experience);
        }
        searchExperiencegSink(searchhResult);
      });
    }else{
      var firebaseQuery = _firebaseintance.collection('experiences');
      if(searchh[2] != null) firebaseQuery = firebaseQuery.where("principal_tag", isEqualTo: searchh[2]);
      if(searchh[1] !=null) firebaseQuery = firebaseQuery.orderBy(searchh[1]);
      
      firebaseQuery
      .limit(10)
      .snapshots()
      .listen((event) {
        searchhResult.clear();
        for(DocumentSnapshot item in event.documents){
          Experience experience = new Experience.fromDocumentSnapshot(item);
          searchhResult.add(experience);
        }
        searchExperiencegSink(searchhResult);
      });
    }
  }

  getStudentResume(Student student){
    List<ResumeExperience> resume = new List<ResumeExperience>();
    
    _firebaseintance
    .collection("students")
    .document(student.uid)
    .collection("history")
    .orderBy("date", descending: true)
    .snapshots()
    .listen((data) { 
      resume.clear();
      for(var item in data.documents){
        ResumeExperience resumeItem = new ResumeExperience.fromDocumentSnapshot(item);
        resume.add(resumeItem);
      }
      historyExperiencegSink(resume);
    });
  }
}