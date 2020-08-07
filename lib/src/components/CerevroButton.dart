import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CerevroButton extends StatelessWidget {

  CerevroButton(
      {@required this.text,
      @required this.color,
      @required this.width,
      @required this.execute});

    final String text;
    final Color color;
    final double width;
    final GestureTapCallback execute;
 
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 10),
        minWidth: this.width,
        color: this.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: execute);
  }
}
