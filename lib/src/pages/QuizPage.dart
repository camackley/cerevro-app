import 'dart:async';
import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cerevro_app/src/models/Questions.dart';
import 'package:cerevro_app/src/providers/Provider.dart';
//import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:toast/toast.dart';

import 'package:cerevro_app/src/providers/Network.dart' as red;

class QuizPage extends StatefulWidget {
  static String tag = "/demo-quiz";

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  
  PageController pageController;
  int _selectIndex = 0;
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: OrientationBuilder(
      builder: (BuildContext context, Orientation orientation){
        if(orientation == Orientation.landscape){
          return Container(
            child: Text("Coloca tú telefono verticalmente", style: TextStyle(fontSize: 24), textAlign: TextAlign.center,)
          );
        }else{
            return SafeArea(
              child: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              children: [
                representation(context, size),
                QuestionsPage(),
            ],  
            onPageChanged: (index) {
              if(isStarted && index == 0){
                pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              }
              if(!isStarted){
                isStarted = true;
              }
            },
          ),
        );
        }
      }
      )
    );
  }

  Widget representation(BuildContext context, Size size){
    return Column(
      children: [
        SizedBox(height: size.height * 0.06),
        Image(image: AssetImage("assets/gif/creativity.gif")),
        SizedBox(height: size.height * 0.02),
        Text("Vamos a ver... \n ¿Cuanto aprendiste?", style: TextStyle(
          fontSize: 27,
          color: Color.fromRGBO(25, 91, 145, 1.0), 
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center),
        SizedBox(height: size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width *0.1),
          child: Text("Después de cada experiencia hacemos una cuantas preguntas, elegidas críticamente para saber que tanto aprendiste...",
          style: TextStyle(
            fontSize: 17
          )
          ),
        ),
        SizedBox(height: size.height * 0.13),
        Icon(Icons.arrow_drop_up, size: 30, color: Color.fromRGBO(25, 91, 145, 1)),
        Text("Desliza hacia arriba para comenzar", textAlign: TextAlign.center, style: TextStyle(fontSize: 15))
      ],
    );
  }
}

class QuestionsPage extends StatefulWidget {

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final provider = new Provider();
  
  PageController pageQuestionController;
  int _selectIndex = 0;

  int globalScore = 100;

  List<String> isSelected = List<String>();

  String tiempo = "Tiempo 00:00 min.";
  Timer _timer;
  int _counter = 0;  
  int _lastCounter = 0;

  @override
  void initState() {
    super.initState();
    pageQuestionController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    pageQuestionController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider.getQuiz('NUjmnbkOeHlJ7qpfHHec');
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
      stream: provider.quizStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(25, 91, 145, 1)
            )
          );
        }else{
          return PageView(
            controller: pageQuestionController,
            children: _getCards(snapshot.data, size),
            onPageChanged: (index){
              try{
                if(index>_selectIndex){
                  print(isSelected[_selectIndex]);
                  scoreManager(snapshot.data[_selectIndex].options, _selectIndex);
                  pageQuestionController.animateToPage(index,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
                  _selectIndex=index;
                  setState((){});
                }else{
                  pageQuestionController.animateToPage(_selectIndex,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
                }
              }catch (e) {
                Toast.show("Debes de selecionar una respuesta", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                pageQuestionController.animateToPage(_selectIndex,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
                  setState((){});
              }
            },
          );
        }
      },
    );
  }

  List<Widget> _getCards(List<Questions> data, Size size){
    List<Widget> questions = new List<Widget>();
    
    int index = 0;
    data.forEach((item){
      item.index = index;
      String action = index == (data.length-1) ? 'Terminar' : 'Siguiente';
      Widget cars = Scaffold(
        body:Column(
          children: [
          SizedBox(height: size.height * 0.04),
          Text("Puntaje: $globalScore", style: TextStyle(
            color: Color.fromRGBO(25, 91, 145, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30
          )),
          SizedBox(height: size.height * 0.05),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tiempo,
                textAlign: TextAlign.end,),
                Text("${index+1}  de ${data.length}",
                textAlign: TextAlign.end,),
              ],
            )
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            width: size.width *1 ,
            height: size.height * 0.2,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
              ),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Center(child: Text(item.title, style: TextStyle(fontSize: 23),textAlign: TextAlign.center,),
              ),
            ),
          )
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            width: size.width,
            child: Column(
              children: _options(item.options, size, context, index),
            )
          ),
        ]
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Icon(action=='Siguiente'?Icons.arrow_forward_ios:Icons.check, color: Colors.white),
          icon:Text(action, style: TextStyle(color: Colors.white)),
          onPressed: (){
            if(action == 'Terminar'){
              print(isSelected[item.index]);
              scoreManager(item.options, item.index);
              _timer.cancel();
              provider.getCurrentStudent();
              _saveHistory();
              _showFinishMessage(context, size);
            }else{
              pageQuestionController.animateToPage(_selectIndex+1,
                    duration: Duration(microseconds: 100), curve: Curves.ease);
            }
          }
        ),
      );
        
      questions.add(cars);
      index +=1;
    });
    return questions;
  }

  List<Widget> _options(List<Options> options, Size size, BuildContext context,int generalIndex){
    List<Widget> _options = new List<Widget>();
    int index = 0;

    while(index<options.length){
      Widget row = new Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Row(
          children: [
            optionCard(options[index] , size, generalIndex),
            SizedBox(width:  size.width * 0.02),
            optionCard(options[index+1], size, generalIndex)
          ]
      ));
      index += 2;
      _options.add(row);
    }

    return _options;
  }

  Widget optionCard(Options option, Size size, int generalIndex){
      var isColorSelected = false;
      try{
        if(isSelected[generalIndex] == option.title){
          isColorSelected =  true;
        }
      }catch (e) {
        isColorSelected = false;
      }

    return Container(
        width: size.width * 0.44,
        height: size.height * 0.1,
        child: GestureDetector(
          child: Card(
            color: isColorSelected ? Color.fromRGBO(244, 131, 25, 1) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            elevation: 10,
            child: Center(child: Text(option.title, style: TextStyle(fontSize: 17, color: isColorSelected ? Colors.white : Colors.black), textAlign: TextAlign.center,)),
          ),
          onTap:(){
            setState(() {
              try {
                isSelected[generalIndex] = option.title;
              } catch (e) {
                isSelected.add(option.title);
              }
            });
          },
      )
      );
  }

  _showFinishMessage(BuildContext context, Size size) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text("Felicitaciones", style: TextStyle(
              fontSize: 30,
              color: Color.fromRGBO(13, 70, 125, 1),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,),
            content: Container(
              height: size.height * 0.3,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  Text("Haz culminado tu primera experiencia Cerevro con:",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center, ),
                  SizedBox(height: size.height * 0.05),
                  Text("$globalScore pts.", style: TextStyle(
                    fontSize: 40, 
                    color: Color.fromRGBO(13, 70, 125, 1),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,),
                  SizedBox(height: size.height * 0.05),
                  Text("Contáctanos ahora para llevar la educación al siguiente nivel",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,),
                ],
              ),
            ),
            actions: <Widget>[
              CerevroButton(
            text: "Comenzar ahora",
            color: Color.fromRGBO(244, 131, 25, 1),
            width: size.width * 0.9,
            execute: () => {provider.lanzarUrl("https://cerevro.app/contacto", context)}),
            Container(
              padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
              width: size.width,
              child: GestureDetector(
                child: Center(child: Text("Ir al home", style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(13, 70, 125, 1)))),
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>ManaggerPrincipalPages()), (_) => false);
                }
              ),
            )
            ],
          );
        });
  }

  void _startTimer(){
    if(_timer != null){
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) { 
       setState((){
         if(_counter < 300){
           _counter ++;
          if(_counter>59){
             int seconds = _counter;
             int minutes = _counter~/60;
             seconds = seconds - (minutes*60);
              tiempo = "Tiempo: 0$minutes:$seconds min.";
          }else{
             tiempo = "Tiempo 00:$_counter min.";  
          }
         }else{
           timer.cancel();
         }
       });
    });
  }

  void scoreManager(List<Options> options, int index){
    options.forEach((option) {
      if(option.isCorrect){
        if(isSelected[index] == option.title){
          globalScore += 50;
        }else{
          globalScore -= 30;
        }
      }
    });
    int deltaTime = _counter - _lastCounter;
    if(deltaTime > 10){
      deltaTime -= 10;
      globalScore -= deltaTime;
      _lastCounter = _counter;
    }
  }
  
  _saveHistory(){
    FirebaseAuth.instance
        .currentUser()
        .then((currentStudent) {
          var data = {
            "token": currentStudent.uid,
            "data": {
              "date": new DateTime.now().millisecondsSinceEpoch,
		          "experience":"experience/NUjmnbkOeHlJ7qpfHHec",
		          "points": globalScore,
		          "title":"Cerevro Demo experiences"
            }
          };
          red.postService('experiences/newHistory', data);
        }).catchError((error){
          print(error);
        });
  }
}