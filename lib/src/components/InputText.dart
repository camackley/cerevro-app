import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  InputField({
    @required this.editingController,
    @required this.isError,
    @required this.textInputType,
    this.hintText,
    this.leading,
    this.errorText
  });

  final TextEditingController editingController;
  final TextInputType textInputType;
  final bool isError;

  final String hintText;
  final IconData leading;
  final String errorText;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: (this.isError) ? Colors.red : Colors.transparent
                  )
                ),
                child: ListTile(
                  leading: Icon(this.leading),
                  title: TextField(
                    controller: this.editingController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: this.textInputType,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: this.hintText,
                        focusColor: Colors.blueAccent),
                  ),
                  trailing: (this.isError) ? Icon(Icons.cancel, color: Colors.red) : SizedBox(),
                )
              ),
        this.isError ? Text(this.errorText, style: TextStyle(color: Colors.red, fontSize: 18.0)) : SizedBox()
      ],
    );
  }

}

class InputController{
  bool isError;
  String errorText;
  TextEditingController editingController;

  InputController(
      {@required this.isError,
      @required this.editingController,
      @required this.errorText});

}