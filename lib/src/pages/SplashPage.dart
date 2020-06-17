import 'package:cerevro_app/src/pages/HomePage.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/static/statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null){
                Navigator.pushReplacementNamed(context, LoginPage.tag)
              }else{
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                builder: (context) => HomePage()))
              }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* _createDB(); */
    return Scaffold(
      backgroundColor: ColorC.principal,
      body: Center(
        child: Container(
          child: Text("Bienvenido!", style: TextStyle(color: ColorC.letter, fontSize: 20.0),)
        )
      )
    );
  }

  void _createDB() {
    var uuid = Uuid();
    final _firestoreInstance = Firestore.instance; 

    List exper = new List();
    for(int i=0; i<101; i++){
      var uid = uuid.v4();
      Map<String, dynamic> data = {   
        "uid": uid,
        "image": "https://picsum.photos/400/300",
        "resume": "Aut omnis tenetur quidem ea accusamus odio.Ut iure ea.",
        "title": "Prueba $i",
        "url": "https://youtu.be/hNAbQYU0wpg",
      };
      _firestoreInstance.collection(BD.experiences).document(uid).setData(data);
      exper.add(uid);
      if(exper.length==5){
        var id = uuid.v4();
        Map<String, dynamic> data = {   
          "uid": id,
          "image": "https://picsum.photos/400/300",
          "resume": "Aut omnis tenetur quidem ea accusamus odio.Ut iure ea.",
          "title": "Topic $i",
          "stars": i,
          "experiences": exper
        };
        _firestoreInstance.collection(BD.topics).document(id).setData(data);
        exper.clear();
      }
    }
  }
}