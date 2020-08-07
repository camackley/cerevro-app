import 'package:cerevro_app/src/static/statics.dart';
import 'package:flutter/material.dart';

class Buton extends StatelessWidget {
  final String text;
  final Icon icon;

  final double width;
  final double height;

  Buton(
      {@required this.text,
      @required this.width,
      @required this.height,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(this.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            )),
      ),
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.5, 1.0),
              end: FractionalOffset(0.0, 0.0),
              colors: [
                ColorC.principal,
                ColorC.principal
              ]),
          borderRadius: BorderRadius.circular(100.0)),
    );
  }
}
