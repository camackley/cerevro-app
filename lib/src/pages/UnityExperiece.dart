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
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnityView(),
    );
  }

  void onUnityViewCreated(UnityViewController controller) {
    print('onUnityViewCreated');

    unityViewController = controller;

    controller.send(
      'Cube',
      'SetRotationSpeed',
      '30',
    );
  }

  void onUnityViewReattached(UnityViewController controller) {
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(UnityViewController controller, String message) {
    print('onUnityViewMessage');

    print(message);
  }
}
