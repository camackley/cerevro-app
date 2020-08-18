import 'package:cerevro_app/src/models/Grade.dart';
import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

import './LoginPage.dart';

/* Custom Widgets */
import '../components/CerevroInputField.dart';

class CreateUserPage extends StatefulWidget {
  static String tag = "ceate-user-page";

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {

  int _currentStep = 0;
  bool _loading = false; 
  final _firestoreInstance = Firestore.instance;
  final _authFirebaseIntance = FirebaseAuth.instance;

  bool _obscureText = true;
  IconData _obscureTextIcon = Icons.remove_red_eye;

  CerevroInputInputController nameController = new CerevroInputInputController();
  CerevroInputInputController emailController = new CerevroInputInputController();
  CerevroInputInputController passwordController = new CerevroInputInputController();
  CerevroInputInputController confirmPasswordController = new CerevroInputInputController();
  CerevroInputInputController schoolCodePasswordController = new CerevroInputInputController();
  DropDownController gradeController = new DropDownController();

  List<DropdownMenuItem<Grade>> gradesDropdown = new List<DropdownMenuItem<Grade>>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 68, 123, 1.0),
      appBar: AppBar(
          leading: GestureDetector(child: Icon(Icons.arrow_back_ios), onTap:(()=>{Navigator.of(context).pop()})),
          title: Text("Crea tú usuario", style: TextStyle(fontSize: 25.0),), elevation: 0),
      body: ModalProgressHUD(child: _getBody(context, size)
      , inAsyncCall: _loading,),
    );
  }

  Widget _getBody(BuildContext context, Size size) {

    return Container(
      height: double.infinity,
      width: size.width,
      decoration: BoxDecoration(  
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
      ),
      child: Column(
        children: [
          Stepper(
            key: Key("4"),
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepTapped: (int step) => setState(() => _currentStep = step),
            onStepContinue: _currentStep < 3 ? () => setState(() => _currentStep += 1) : null,
            onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
            controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}){
              return Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      onPressed: () {
                        if(_validate(_currentStep) && _validate(_currentStep) != null){
                          onStepContinue();
                        }else{
                          setState(() {});
                        }
                      },
                      child: Container(width: size.width * 0.2, child: Center(child: Text("Siguiente", style: TextStyle(color: Colors.white, fontSize: 17),))), color:Color.fromRGBO(244, 131, 25, 1),),
                    SizedBox(width: 20.0,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      onPressed: onStepCancel,
                      child: Container(width: size.width * 0.2, child: Center(child: Text("Atrás", style: TextStyle(color: Colors.white, fontSize: 17),))), color:Color.fromRGBO(25, 91, 145, 1),),                
                ],),
              );
            },
            steps: [
              new Step(
                title: Text('¿Quién eres?', style: TextStyle(fontSize: 17),),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nombre", style: TextStyle(fontSize: 17)),
                      CerevroInputField(
                        editingController: nameController.editingController,
                        isError: nameController.isError,
                        textInputType: TextInputType.name,
                        errorText: nameController.errorText,
                      )
                  ],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              new Step(
                title: Text('Crea tú cuenta', style: TextStyle(fontSize: 17),),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("Coreo electronico", style: TextStyle(fontSize: 17)),
                      CerevroInputField(
                        editingController: emailController.editingController,
                        isError: emailController.isError,
                        textInputType: TextInputType.emailAddress,
                        errorText: emailController.errorText,
                      ),
                      SizedBox(height: 10,),
                      Text("Contraseña", style: TextStyle(fontSize: 17)),
                      getPasswordField (passwordController),
                      SizedBox(height: 10,),
                      Text("Confirma la contraseña", style: TextStyle(fontSize: 17)),
                      getPasswordField (confirmPasswordController),
                  ],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              new Step(
                title: Text('¿En qué colegio estudias?', style: TextStyle(fontSize: 17),),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("Código de tu colegio", style: TextStyle(fontSize: 17)),
                      CerevroInputField(
                        editingController: schoolCodePasswordController.editingController,
                        isError: schoolCodePasswordController.isError,
                        textInputType: TextInputType.numberWithOptions(decimal: false, signed: false),
                        errorText: schoolCodePasswordController.errorText,
                      ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
              new Step(
                title: Text('¿En qué grado estas?', style: TextStyle(fontSize: 17),),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("Selecciona tu salón", style: TextStyle(fontSize: 17)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(230, 230, 230, 1),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                          color: (gradeController.isError) ? Colors.red : Colors.transparent
                         )
                        ),
                        child: ListTile(
                          title: DropdownButton<Grade>(
                            value: gradeController.controller,
                            icon: Icon(Icons.arrow_drop_down, color: Color.fromRGBO(13, 70, 725, 1),),
                            iconSize: 20,
                            elevation: 10,
                            items: gradesDropdown,
                            underline: SizedBox(),
                            onChanged: (Grade gradeSelected){
                              setState(() {
                                gradeController.controller= gradeSelected;
                              });
                            },
                          ),
                          trailing: (gradeController.isError) ? Icon(Icons.cancel, color: Colors.red) : SizedBox(),
                        )
                      ),
                      gradeController.isError ? Text(gradeController.errorText, style: TextStyle(color: Colors.red, fontSize: 18.0)) : SizedBox()
                  ],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),          
          SizedBox(height: size.height * 0.15,),
          Divider(),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.15, vertical: 20),
              child: Text("¿Ya tines cuenta? Ingresa ahora", 
                      style: TextStyle(color: Color.fromRGBO(25, 91, 145, 1), fontSize: 17, fontWeight: FontWeight.bold),),
            ),
            onTap: () => {
              Navigator.of(context).pushNamed(LoginPage.tag)
            }
          ),
        ],
      ),
    );
  }

  _validate(int currentStep) {

    switch(currentStep){
      case 0:
        bool response = true;
        if(nameController.editingController.text.length < 2 ){
            nameController.isError = true;
            nameController.errorText = "Debes de ingresar tú nombre";
            response = false;
        }else{
          nameController.isError = false;
          nameController.errorText = "";
        }

        return response;
      
      case 1:
        bool response = true;
        bool emailIsValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.editingController.text);
        
        if(!emailIsValid){
          emailController.isError = true;
          emailController.errorText = "Debes de ingresar un correo válido";
          response = false;
        }else{
          emailController.isError = false;
          emailController.errorText = "";
        }

        if(passwordController.editingController.text.length < 9){
          passwordController.isError = true;
          passwordController.errorText = "Debes de ingresar una contraseña segura";
          response = false;
        }else{
          passwordController.isError = false;
          passwordController.errorText = "";
        }

        if(passwordController.editingController.text != confirmPasswordController.editingController.text ){
          confirmPasswordController.isError = true;
          confirmPasswordController.errorText = "Las contraseñas deben de ser iguales";
          response = false;
        }else{
          confirmPasswordController.isError = false;
          confirmPasswordController.errorText = "";
        }

        return response;
        break;

      case 2:
        if(schoolCodePasswordController.editingController.text.length <= 5 ){
          schoolCodePasswordController.isError = true;
          schoolCodePasswordController.errorText = "Debes de ingresar un código valido";
          return false;
        }else{
          setState(() {
            _loading = true;
          });
          schoolCodePasswordController.isError = false;
          schoolCodePasswordController.errorText = "";
          
          var code = schoolCodePasswordController.editingController.text;
          code = code.replaceAll(",", "");
          code = code.replaceAll(".", "");

          _firestoreInstance
            .collection("schools")
            .where("code", isEqualTo: int.parse(code))
            .snapshots()
            .listen((data) {
              if(data.documents.length==0){  
                schoolCodePasswordController.isError = true;
                schoolCodePasswordController.errorText = "No conocemos este código, porfa verifícalo";
                setState(() {
                  _loading = false;
                  _currentStep = 2;
                });
              }else{
                _firestoreInstance
                  .collection("grade")
                  .where("school_id", isEqualTo: data.documents[0].documentID)
                  .orderBy("name", descending: false)
                  .limit(10)
                  .snapshots()
                  .listen((data) {
                    data.documents.forEach((item) {
                      Grade grade = new Grade.fromJson(item);
                      DropdownMenuItem<Grade> gradeDropDown = new DropdownMenuItem<Grade>(
                        value: grade,
                        child: Container(child: Text(grade.name)),
                      );
                      gradesDropdown.add(gradeDropDown);
                    });
                    gradeController.controller = gradesDropdown[0].value;
                    setState(() {
                      _loading = false;
                      _currentStep = 3;
                    });
                  }).onError((e){
                    setState(() {
                      schoolCodePasswordController.isError = true;
                      schoolCodePasswordController.errorText = "Error interno, porfavor intenta más tarde";
                      _loading = false;
                    });
                  });
              }
            }).onError((e){
              setState(() {
                _loading = false;
              });
            });
        }
        break;
      
      case 3:
        if(gradeController.controller == null){
          gradeController.isError=true;
          gradeController.errorText="Debes de seleccionar un grado";
        }else{
          setState(() {
            _loading = true;
          });
          gradeController.isError=false;
          gradeController.errorText="";
          _createUser();
          return true;
        }
        break;
    }
  
  }

  Widget getPasswordField(CerevroInputInputController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: (controller.isError) ? Colors.red : Colors.transparent
                  )
                ),
                child: ListTile(
                  title: TextField(
                    obscureText: _obscureText,
                    controller: controller.editingController,
                    cursorColor: Colors.blueAccent,
                    decoration: InputDecoration(
                        border: InputBorder.none,
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
        controller.isError ? Text(controller.errorText, style: TextStyle(color: Colors.red, fontSize: 18.0)) : SizedBox()
      ],
    );
  }

  void _createUser() {
    String _lastemail = "";
    if(_lastemail!=emailController.editingController.text){
      _lastemail=emailController.editingController.text;
    _authFirebaseIntance.createUserWithEmailAndPassword(
        email: emailController.editingController.text, 
        password: passwordController.editingController.text
    )
    .then((authRes) {
      var data = {
        "state" : true,
        "name" : nameController.editingController.text,
        "token": authRes.user.uid,
        "email": emailController.editingController.text,
        "avatar_url": "",
        "grade_id" : gradeController.controller.uid,
        "school_id":  gradeController.controller.schoolId
      };
      _firestoreInstance
        .collection("students")
        .document(authRes.user.uid)
        .setData(data)
          .then((data) {
            Toast.show("Bienvenido a Cerevro...", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>ManaggerPrincipalPages()), (_) => false);
            setState(() {
              _loading=false;
            });
          }).catchError((e){
            Toast.show("Error al insertar los datos", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          });
    })
    .catchError((e){
        emailController.isError = true;
        emailController.errorText = "Oh no! este correo ya exite";

        setState(() {
          _loading=false;          
          _currentStep=1;          
        });
      }
    );
  }
  }

}

class DropDownController{
  bool isError = false;
  String errorText = "";
  Grade controller;
}