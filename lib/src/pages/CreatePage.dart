import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/components/textCamps.dart';
import 'package:cerevro_app/src/pages/HomePage.dart';
import 'package:cerevro_app/src/static/statics.dart';
import 'package:cerevro_app/src/utils/Firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePage extends StatefulWidget {
  CreatePage({Key key}) : super(key: key);
  static String tag=  "create-page";

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController nombre = new TextEditingController();
  TextEditingController edad = new TextEditingController();
  TextEditingController celular = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController clave = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(child: Icon(Icons.arrow_back_ios), onTap: () => Navigator.pop(context)),
        title: Text("Registrate con tu email"),
        backgroundColor: CerevroColors.accent,
      ),
      body: SingleChildScrollView(
              child: Column(
                children: <Widget>[_form(context), 
                SizedBox(height: 10.0,),
                /* FlatButton(
                  child:Buton(
                   height: 50,
                   width: 200,
                   text: "Registrarme ahora",
                ), onPressed: () => _validateCamps(),), */
                SizedBox(height: 40.0,),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color: Colors.black38,
                    ),
                  ),                 
                GestureDetector(
                    child: SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("¿Ya tines cuenta?",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0)),
                          Text(" Ingresa aquí",
                              style: TextStyle(
                                  color: CerevroColors.accent,
                                  fontSize: 16.0)),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.pop(context)
                  ),]))
    );
  }
  
  Widget _form(BuildContext context){

    bool _obscureText = true;
    IconData _obscureTextIcon = Icons.remove_red_eye;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _camp(context, "*Nombre completo", nombre, TextInputType.text, Icons.sentiment_satisfied),
          _camp(context, "Edad", edad, TextInputType.number, Icons.bubble_chart),
          _camp(context, "Celular", celular, TextInputType.number, Icons.phone_android),
          _camp(context, "*Email", email, TextInputType.emailAddress, Icons.alternate_email),
          SizedBox(height: 10.0,),
          Text(" *Contraseña", style: TextStyle(fontSize: 18,), textAlign: TextAlign.right,),
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: ListTile(
                title: TextField(
                  controller: clave,
                  cursorColor: Colors.blueAccent,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Contraseña",
                      focusColor: Colors.blueAccent),
                ),
                leading: Icon(Icons.vpn_key),
                /* trailing: GestureDetector(
                    child: Icon(_obscureTextIcon),
                    onTap: () {
                      if (_obscureText) {
                        _obscureText = false;
                        _obscureTextIcon = Icons.visibility_off;
                      } else {
                        _obscureTextIcon = Icons.remove_red_eye;
                        _obscureText = true;
                      }
                      setState(() {});
                    }) */), 
          ),
       ]
    ));
  }

  Widget _camp(BuildContext context, String hintText, TextEditingController textController, TextInputType type, IconData icon) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("  "+hintText, style: TextStyle(fontSize: 18,), textAlign: TextAlign.right,),
          TextCamps(name: hintText, controller: textController, icon: icon, type: type)
        ],
      ),
    );
  }

  _createAccount() {
      String txtNombre = nombre.text;
      String txtEdad = edad.text;
      String txtCelular = celular.text;
      String txtEmail = email.text;
      String txtClave  = clave.text;
      FirebaseAuth.instance
                  .createUserWithEmailAndPassword(email: txtEmail, password: txtClave)
                  .then((currentUser){
                    final _firestoreInstance = Firestore.instance;
                    Map<String, dynamic> data = {   
                      "token": currentUser.user.uid,
                      "name":txtNombre,
                      "age": txtEdad,
                      "phone": txtCelular,
                      "email": txtEmail,
                      "topics": []
                    };
                    _firestoreInstance.collection(BD.users).document(currentUser.user.uid).setData(data);
                    _showMessageToContinue(context, "Usuario creado correctamente", 'Bienvenido $txtNombre! entra y disfruta la expriencia Cerevro');
                  });
  }
  
  Widget _showMessage(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title, style: TextStyle(color: CerevroColors.accent)),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",
                    style: TextStyle(color: CerevroColors.accent)),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });

    return Container();
  }

  Widget _showMessageToContinue(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title, style: TextStyle(color: CerevroColors.accent)),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",
                    style: TextStyle(color: CerevroColors.accent)),
                onPressed: (){
                  Navigator.of(context).pop();
                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage()), (_) => false);
                } ,
              )
            ],
          );
        });

    return Container();
  }

  _validateCamps() {
    bool validateName = _validateStr(nombre.text, 2);
    if (!validateName) {
      _showMessage(context, "Error", "Debe de ingresar un nombre válido");
      return;
    }

    bool validateEmail = _validateStr(email.text, 0);

    if (!validateEmail) {
      _showMessage(context, "Error", "Debe de ingresar un email válido");
      return;
    }

    bool validatePassword = _validateStr(clave.text, 1);
    if (!validatePassword) {
      _showMessage(context, "Error", "La contraseña debe de tener mas de 8 caracteres");
      return;
    }

    onChargin();
    _createAccount();
  }

  onChargin() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        child: Center(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ))));
  }

  bool _validateStr(String word, int type) {
    if (word.length == 0) {
      return false;
    }

    if (type == 0) {
      bool emailValid =
          RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(word);
      return emailValid;
    }

    if(type==1){
      bool valid = (word.length>7);
      return valid;
    }

    if(type==2){
      bool valid = (word.length>0);
      return valid;
    }
    
    return true;
  }
}