import 'package:cerevro_app/src/pages/CreatePage.dart';
import 'package:cerevro_app/src/pages/ExperienciaPage.dart';
import 'package:cerevro_app/src/pages/SplashPage.dart';
import 'package:cerevro_app/src/pages/WebViewPage.dart';
import 'package:cerevro_app/src/utils/Preferences.dart';
import 'package:flutter/material.dart';

import 'package:cerevro_app/src/pages/HomePage.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  final preferences = UserPreferences();
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
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        HomePage.tag: (context)=>HomePage(),
        LoginPage.tag: (context) =>LoginPage(),
        CreatePage.tag: (context)=>CreatePage(),
        ExperiencePage.tag: (context)=>ExperiencePage(),
        WebViewPage.tag: (context)=>WebViewPage(),
      },
    );
  }
}