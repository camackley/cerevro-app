import 'package:flutter/material.dart';

class TextCamps extends StatelessWidget {
  final String name;
  final IconData icon;

  final TextEditingController controller;
  final TextInputType type;

  TextCamps(
      { this.name,
      @required this.controller,
      this.icon, 
      @required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: ListTile(
              title: TextField(
                controller: controller,
                cursorColor: Colors.blueAccent,
                keyboardType: this.type,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: this.name,
                    focusColor: Colors.blueAccent),
              ),
              leading: Icon(this.icon),
            ),
          );
  }
}