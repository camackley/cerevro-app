import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CerevroInputField extends StatelessWidget {

  CerevroInputField({
    @required this.editingController,
    @required this.isError,
    @required this.textInputType,
    this.hintText,
    this.leading,
    this.errorText,
    this.onChange
  });

  final TextEditingController editingController;
  final TextInputType textInputType;
  final bool isError;

  final String hintText;
  final IconData leading;
  final String errorText;

  final Function(String) onChange;


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
                  leading: (this.leading != null) ? Icon(this.leading) : null,
                  title: TextField(
                    controller: this.editingController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: this.textInputType,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: this.hintText,
                        focusColor: Colors.blueAccent),
                    onChanged: (this.onChange != null) ?  this.onChange : null,
                  ),
                  trailing: (this.isError) ? Icon(Icons.cancel, color: Colors.red) : SizedBox(),
                )
              ),
        this.isError ? Text(this.errorText, style: TextStyle(color: Colors.red, fontSize: 18.0)) : SizedBox()
      ],
    );
  }

}

class CerevroInputInputController{
  bool isError = false;
  String errorText = "";
  TextEditingController editingController = new TextEditingController();
}