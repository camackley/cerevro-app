import 'dart:convert';
import 'package:cerevro_app/src/pages/QuizPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';

class UnityExperiecePage extends StatefulWidget {
  static String tag = "unity-experience-page";

  @override
  _UnityExperiecePageState createState() => _UnityExperiecePageState();
}

class _UnityExperiecePageState extends State<UnityExperiecePage> {
  UnityViewController unityViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnityView(
        key: Key("demo"),
        onCreated: onUnityViewCreated,
        onMessage: onUnityViewMessage,
        onReattached: onUnityViewReattached,
      ),
    );
  }

  void onUnityViewCreated(UnityViewController controller) {
    print('onUnityViewCreated');

    unityViewController = controller;
  }

  void onUnityViewReattached(UnityViewController controller) {
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(UnityViewController controller, String data) {
    print('onUnityViewMessage');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>QuizPage()), (_) => false);
  }
}

class Messages {
  int id;
  dynamic data;

  Messages.fromMap(Map data){
    this.id = data["id"];
    this.data = data["data"];
  }
}
