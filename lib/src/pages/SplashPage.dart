import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 91, 145, 1),
      body: Center(
        child: Container(
          child: Text("Bienvenido!", style: TextStyle(color: Colors.white, fontSize: 40),),)
        )
      );
  }
}