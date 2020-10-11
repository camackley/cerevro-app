import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/pages/WelcomeScrollPage.dart';
import 'package:cerevro_app/src/providers/Provider.dart';
import 'package:cerevro_app/src/utils/user_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  
  final preferences = new UserPreferences();
  @override
  initState() {
    super.initState();
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) async {
              if (currentUser == null){
                if(preferences.isFirstTime) {
                  preferences.isFirstTime = false;
                  Navigator.pushNamed(context, WelcomeScrollpage.tag);
                }else{
                  Provider().getCurrentStudent();
                  Navigator.pushReplacementNamed(context, LoginPage.tag);                  
                }
              }else{
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                builder: (context) => ManaggerPrincipalPages()));
              }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _createDB();
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 91, 145, 1),
      body: Center(
        child: Container(
          child: Text("Bienvenido!", style: TextStyle(color: Colors.white, fontSize: 40),),)
        )
      );
  }

  
  void _createDB() {
    final _firestoreInstance = Firestore.instance; 
    var experiences = [
      {
       "creation_date": DateTime.now().millisecondsSinceEpoch,
       "duration": "31:00",
       "likes": 0,
       "miniature": "",
       "name": "Conozcamos roma",
       "state": true,
       "summary": "Necessitatibus voluptate aperiam rerum totam iusto quia voluptas itaque. Necessitatibus voluptate aperiam rerum totam iusto quia voluptas itaque."
      },
      {
       "creation_date": DateTime.now().millisecondsSinceEpoch,
       "duration": "28:00",
       "likes": 0,
       "miniature": "",
       "name": "Vamos al mueso",
       "state": true,
       "summary": "Sed eveniet consequatur aliquam beatae voluptas ad nam eum nobis. Sed eveniet consequatur aliquam beatae voluptas ad nam eum nobis"
      },
      {
       "creation_date": DateTime.now().millisecondsSinceEpoch,
       "duration": "30:00",
       "likes": 0,
       "miniature": "",
       "name": "Conversemos en el parque",
       "state": true,
       "summary": "Nostrum sequi non sit doloremque et. Nostrum sequi non sit doloremque et."
      },
    ];

    experiences.map((e) => {  
      _firestoreInstance.collection("experiences").document().setData(e)
    });
  }
}