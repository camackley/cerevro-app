import 'package:cerevro_app/src/pages/ExperienciaPage.dart';
import 'package:cerevro_app/src/pages/SplashPage.dart';
import 'package:cerevro_app/src/pages/WebViewPage.dart';
import 'package:cerevro_app/src/utils/user_preferences.dart';
import 'package:flutter/material.dart';

import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/pages/CreateUserPage.dart';
import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';

import 'package:cerevro_app/src/pages/WelcomeScrollPage.dart';

 
void main(){
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  
  final preferences = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primaryColor: Color.fromRGBO(14, 68, 123, 1.0), 
              accentColor: Color.fromRGBO(244, 131, 25, 1.0),
              fontFamily: 'VagRoundedStd'
      ),
      title: 'Cerevro',
      home: _homeState(),
      routes: <String, WidgetBuilder>{
        ManaggerPrincipalPages.tag: (context)=> ManaggerPrincipalPages(),
        LoginPage.tag: (context) =>LoginPage(),
        CreateUserPage.tag: (context) => CreateUserPage(),
        ExperiencePage.tag: (context)=>ExperiencePage(),
        WebViewPage.tag: (context)=>WebViewPage(),
        WelcomeScrollpage.tag: (context) => WelcomeScrollpage(),
      },
    );
  }

  Widget _homeState(){
    preferences.initPrefs();
    return SplashPage();
  }
}