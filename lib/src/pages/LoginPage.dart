import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/pages/CreateUserPage.dart';
import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';
import 'package:cerevro_app/src/providers/StudentProvider.dart';
import 'package:cerevro_app/src/utils/Firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

/* Custom Widgets */
import '../components/CerevroInputField.dart';
import '../components/CerevroButton.dart';

class LoginPage extends StatefulWidget {
  static String tag = "login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  CerevroInputInputController emailController = new CerevroInputInputController();

  CerevroInputInputController passwordController = new CerevroInputInputController();


  bool _obscureText = true;
  IconData _obscureTextIcon = Icons.remove_red_eye;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     return Scaffold(
            backgroundColor: Color.fromRGBO(14, 68, 123, 1.0),
            body:  Container (
              child: ListView(
                shrinkWrap: true,
                  children: [
                    Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: size.height * 0.03),
                      Hero(
                        tag: "header-login.webp",
                        child: Image(image: AssetImage("assets/img/header-login.webp"))
                      ),
                      SizedBox(height: size.height * 0.05),
                      _getLoginForm(context, size),
                  ],
                ),
                  ]
              ),
            ),
    );
  }

   Widget  _getLoginForm(context, size) {
    return Container(
      height: size.height * 0.6,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.8,
            height: size.height * 0.08 ,
            child: Image(
              image: AssetImage("assets/img/logo-horizontal.webp"),
            ),
          ),
          Text("Ingresar", style: TextStyle(fontSize: 20),),
          Container(
            margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05, top: 20),
            child: CerevroInputField(
              editingController: emailController.editingController,
              isError: emailController.isError,
              textInputType: TextInputType.emailAddress,
              hintText: "Correo",
              leading: Icons.email,
              errorText: emailController.errorText,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: !emailController.isError ? 20 : 10),
            child: getPasswordField()
          ),
          CerevroButton(
            text: "Ingresar",
            color: Color.fromRGBO(244, 131, 25, 1),
            width: size.width * 0.9,
            execute: () => _login(context)),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: !emailController.isError ? !passwordController.isError ? 30 : 10 : 10),
              child: Text("¿perdiste tú contraseña?",
                      style: TextStyle(color: Color.fromRGBO(25, 91, 145, 1), fontSize: 18))),
            onTap: () =>  _showinputMessage(context, "Recupera tú cuenta", "Recibiras un correo con un link para recuperar tu cuenta"),
          ), 
          CerevroButton(
            text: "Crear cuenta",
            color: Color.fromRGBO(25, 91, 145, 1),
            width: size.width * 0.9,
            execute: () => Navigator.of(context).pushNamed(CreateUserPage.tag)),
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
            title: Text(title, style: TextStyle(color:Color.fromRGBO(244, 131, 25, 1))),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",
                    style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1))),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });

    return Container();
  }

  Widget _showinputMessage(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title, style: TextStyle(color: Color.fromRGBO(25, 91, 145, 1))),
            content: Container(
              height: 88,
              child: Column(
                children: [
                    Text(content),  
                    TextField(
                  controller: emailController.editingController,
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
                    style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1))),
                onPressed: ((){
                  if(_validateStr(emailController.editingController.text, 0)){
                  FirebaseUtils().resetPassword(emailController.editingController.text);
                  Navigator.of(context).pop();
                  Toast.show("Correo enviado, te esperamos devuelta", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
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
    bool validateEmail = _validateStr(emailController.editingController.text, 0);

    if (!validateEmail) {
      emailController.isError = true;
      emailController.errorText="Ingresa un correo válido";
    }else{
      emailController.isError = false;
      emailController.errorText = "";
    }

    bool validatePassword = _validateStr(passwordController.editingController.text, 1);
    if (!validatePassword) {
      passwordController.isError = true;
      passwordController.errorText = "Debe de ingresar una clave válida";
    }else{
      passwordController.isError = false;
      passwordController.errorText = "";
    }

    if(!validatePassword | !validateEmail){
      setState(() {});
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
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
            email: emailController.editingController.text, password: passwordController.editingController.text);
      StudentProvider().getCurrentStudent();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>ManaggerPrincipalPages()), (_) => false);
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

  Widget getPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: (passwordController.isError) ? Colors.red : Colors.transparent
                  )
                ),
                child: ListTile(
                  leading: Icon(Icons.vpn_key),
                  title: TextField(
                    obscureText: _obscureText,
                    controller: passwordController.editingController,
                    cursorColor: Colors.blueAccent,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Contraseña",
                        focusColor: Colors.blueAccent),
                  ),
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
                    }
                  ),
                )
              ),
        passwordController.isError ? Text(passwordController.errorText, style: TextStyle(color: Colors.red, fontSize: 18.0)) : SizedBox()
      ],
    );
  }
}