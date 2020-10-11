import 'dart:async';
import 'package:cerevro_app/src/models/Questions.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cerevro_app/src/models/Experience.dart';

import 'package:cerevro_app/src/models/Student.dart';
import 'package:cerevro_app/src/models/Learning.dart';
import 'package:cerevro_app/src/providers/Network.dart' as red;

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

  final _quizStream = StreamController<List<Questions>>.broadcast();

  Function(List<Questions>) get quizSink => _quizStream.sink.add;
  Stream<List<Questions>> get quizStream => _quizStream.stream;


  /* Firebase Instance */
  var _firebaseintance = Firestore.instance; 

  void disposeStream(){
    _studentStream?.close();
    _learningStream?.close();
    _searchExperienceStream?.close();
    _historyExperienceStream?.close();
    _quizStream?.close();
  }

  getCurrentStudent() async {
     FirebaseAuth.instance
        .currentUser()
        .then((currentStudent) {
          _firebaseintance
            .collection("students")
            .document(currentStudent.uid)
            .snapshots()
            .listen((data) async {
              Student student = Student.fromDocumentSnapshot(data);
              
              //General score
              red.GeneralServiceResponse historyData = await red.getService("user/score/${student.uid}");
              Score score = Score.fromJson(historyData.body);
              student.totalPoints = score.total;

              //Grade name
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

  getSearch(List<String> search){
    List<Experience> searchResult = new List<Experience>();
    dynamic firebaseQuery = _firebaseintance.collection('experiences');
    if(search[2] != null) firebaseQuery = firebaseQuery.where("principal_tag", isEqualTo: search[2]);
    if(search[1] !=null) firebaseQuery = firebaseQuery.orderBy(search[1]);

    if(search[0].length > 0){
      firebaseQuery
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
    }).onError((error){
      print(error);
      historyExperiencegSink(resume);
    });
  }

  getQuiz(String uid) async {
    red.GeneralServiceResponse historyData = await red.getService("experiences/getQuiz/$uid");
    List<Questions> questions = new List<Questions>();
    historyData.body.forEach((item) {
      Questions question = new Questions.fromJson(item);
      questions.add(question);
    });
    quizSink(questions);
  }

  sendToWpp(String content, BuildContext context){
    FirebaseAuth.instance
        .currentUser()
        .then((currentStudent) {
          _firebaseintance
            .collection("students")
            .document(currentStudent.uid)
            .snapshots()
            .listen((data) {
              Student student = Student.fromDocumentSnapshot(data);
              String message = 'Hola! soy ${student.name} y tengo una idea para crear una experiencia, hagamos algo increible 🚀';
              String link = 
                         'https://api.whatsapp.com/send?phone=573002645663&text=$message';              
              lanzarUrl(link, context);
            });
        });
  }

  void lanzarUrl(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Toast.show("Error al inciar el chat", context);
  }
}
}

class Score{
  int total;
  Score.fromJson(Map data){
    total = data["total_points"];
  }
}