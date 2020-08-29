import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CerevroFeature extends StatelessWidget {

  CerevroFeature({
    @required this.name,
    @required this.isSelected,
    @required this.queryExcute,
  });

  final String name;
  final bool isSelected;
  final Function() queryExcute;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: this.isSelected ? Color.fromRGBO(244, 131, 25, 1) : Colors.white,
            ),
            borderRadius: BorderRadius.circular(15.0)
          ),
          color: this.isSelected ? Color.fromRGBO(244, 131, 25, 0.4) : Colors.white,
          elevation: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(this.name, style: TextStyle(
              color: this.isSelected ? Colors.white : Colors.black,
            ),)),
        ),
      onTap: this.queryExcute
    );
  }

}