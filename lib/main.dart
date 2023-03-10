import 'package:cerevro_app/src/pages/QuizPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/pages/CreateUserPage.dart';
import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';
import 'package:cerevro_app/src/pages/ExperienciaPage.dart';
import 'package:cerevro_app/src/pages/SplashPage.dart';
import 'package:cerevro_app/src/pages/WelcomeScrollPage.dart';
import 'package:cerevro_app/src/utils/user_preferences.dart';
import 'package:flutter/services.dart';

 
void main(){
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  
  final preferences = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primaryColor: Color.fromRGBO(3, 58, 102, 1), 
              accentColor: Color.fromRGBO(244, 131, 25, 1.0),
              fontFamily: 'VagRoundedStd'
      ),
      title: 'Cerevro',
      home: _homeState(),
      routes: <String, WidgetBuilder>{
        WelcomeScrollpage.tag: (context) => WelcomeScrollpage(),
        CreateUserPage.tag: (context) => CreateUserPage(),
        LoginPage.tag: (context) =>LoginPage(),
        ManaggerPrincipalPages.tag: (context)=> ManaggerPrincipalPages(),
        ExperiencePage.tag: (context)=>ExperiencePage(),
        QuizPage.tag: (context) => QuizPage(),
      },
    );
  }

  Widget _homeState(){
    preferences.initPrefs();
    return SplashPage();
  }
}