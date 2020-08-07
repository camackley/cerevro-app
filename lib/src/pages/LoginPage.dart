import 'package:cerevro_app/src/components/button.dart';
import 'package:cerevro_app/src/pages/CreatePage.dart';
import 'package:cerevro_app/src/utils/preferences.dart';
import 'package:cerevro_app/src/pages/HomePage.dart';
import 'package:cerevro_app/src/static/statics.dart';
import 'package:cerevro_app/src/utils/Firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static String tag = "login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final preferences = UserPreferences();

  bool _obscureText = true;
  IconData _obscureTextIcon = Icons.remove_red_eye;

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: preferences.initPrefs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: ColorC.letter,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorC.principal,
              ),
            ),
          );
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _background(),
                  _loginForm(context),
                  SizedBox(
                    height: 30.0,
                  ),       
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
                          Text("¿No tines cuenta?",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0)),
                          Text(" Registrarte ahora",
                              style: TextStyle(
                                  color: ColorC.principal,
                                  fontSize: 16.0)),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.of(context).pushNamed(CreatePage.tag)
                  ),
                ],
              ),
            ),
    );
        }
      });
  }

  Widget _background() { 
    final background = Container(
      color: ColorC.letter,
    );

    final box = Container(
      width: 500,
      height: 300,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.5, 1.0),
              end: FractionalOffset(0.0, 0.0),
              colors: [
                ColorC.principal,
                ColorC.principal
              ]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100.0))),
    );

    final image = Container(
      width: 500,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(30),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: ColorC.letter,
                /* image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/logotipo.png")), */
                borderRadius: BorderRadius.circular(100)
              ),
              child: Image(image: AssetImage("assets/logotipo.png"),)
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );

    return Stack(
      children: <Widget>[background, box, image],
    );
  }

  Widget _loginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: ListTile(
              title: TextField(
                controller: email,
                cursorColor: Colors.blueAccent,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Correo",
                    focusColor: Colors.blueAccent),
              ),
              leading: Icon(Icons.email),
            ),
          ),
          SizedBox(
            height: 17.0,
          ),
          Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: ListTile(
                title: TextField(
                  controller: password,
                  cursorColor: Colors.blueAccent,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Contraseña",
                      focusColor: Colors.blueAccent),
                ),
                leading: Icon(Icons.vpn_key),
                trailing: GestureDetector(
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
                    })), 
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                child: Text("¿Perdiste tu cuenta?",
                              style: TextStyle(
                                  color: ColorC.principal,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16.0)),
                onTap:  () => _inputMessage(
                        context,
                       "Recuperar cuenta",
                      "Recibiras un correo con un link para recuperar tu cuenta"),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          FlatButton(
            child: Buton(
              height: 50,
              width: 250,
              text: "Ingresar ahora",
            ),
            onPressed: () => _login(context),
          )
        ],
      ),
    );
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
            title: Text(title, style: TextStyle(color: ColorC.principal)),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",
                    style: TextStyle(color: ColorC.principal)),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });

    return Container();
  }

  Widget _inputMessage(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title, style: TextStyle(color: ColorC.principal)),
            content: Container(
              height: 88,
              child: Column(
                children: [
                    Text(content),  
                    TextField(
                  controller: email,
                  cursorColor: Colors.blueAccent,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Correo",
                      focusColor: Colors.blueAccent),
                )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",
                    style: TextStyle(color: ColorC.principal)),
                onPressed: ((){
                  if(_validateStr(email.text, 0)){
                  FirebaseUtils().resetPassword(email.text);
                  Navigator.of(context).pop();
                  Toast.show("Correo enviado", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }else{
                  Toast.show("Verifique su correo", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                })
              )
            ],
          );
        });

    return Container();
  }

  void _login(BuildContext context) {
    bool validateEmail = _validateStr(email.text, 0);

    if (!validateEmail) {
      _showMessage(context, "Error", "Debe de ingresar un email valido");
      return;
    }

    bool validatePassword = _validateStr(password.text, 1);
    if (!validatePassword) {
      _showMessage(context, "Error", "Debe de ingresar una clave valida");
      return;
    }
    onChargin();
    signIn();
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

    return true;
  }

  void signIn() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await _firebaseAuth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>HomePage()), (_) => false);
    } catch (e) {
      Navigator.pop(context, 1);
      print(e);
      _showMessage(context, "Error", "Usuario y/o contraseña incorrectos");
    }
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
}