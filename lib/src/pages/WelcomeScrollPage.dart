import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WelcomeScrollpage extends StatelessWidget {
  static String tag = "welcome-scroll-page";

  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          _page1(size, context),
          _page2(size, context),
          _page3(size, context)
        ]
      ),
    );
  }

  Widget _page1(Size size, BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        children: [
          SizedBox(height: 100,),
          Image(image: AssetImage("assets/img/logo-vertical.webp"), width: size.width* 0.7,),
          SizedBox(height: 80,),
          Text("Mejoramos tú calida educativa", style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1), fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 29,),
          Row(
            children: [
              Container(
                width: size.width* 0.38,
                child: Column(
                  children: [
                    Text("90%", style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1), fontSize: 25,),),
                    Text("Más de probabilidad de recordar lo estudiado", style: TextStyle(fontSize: 17, color:  Color.fromRGBO(25, 91, 145, 1)), textAlign: TextAlign.center,)
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Container(
                width: size.width* 0.38,
                child: Column(
                  children: [
                    Text("84%", style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1), fontSize: 25),),
                    Text("De aumento en la motivación de los alumnos", style: TextStyle(fontSize: 17, color:  Color.fromRGBO(25, 91, 145, 1)), textAlign: TextAlign.center, )
                  ],
                ),
              ),
            ],
          ),
          _buttomOptions(0, "Siguiente", size, context)
        ],
      ),
    );
  }
  
  Widget _page2(Size size, BuildContext context){
    return Column(
      children: [ 
        SizedBox(height: 100,),
        Image(image: AssetImage("assets/img/splash-2.webp"), width: size.width* 0.8,),
        SizedBox(height: 60,),
        Text("Basados en Gamificación", style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1), fontSize: 25, fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Text("Todas nuestras experiencias están diseñadas para que el estudiante aprenda con una motivción constante", style: TextStyle(fontSize: 20, color:  Color.fromRGBO(25, 91, 145, 1)), textAlign: TextAlign.center,)),
        SizedBox(height: 8,),
        _buttomOptions(1, "Siguiente", size, context),
      ]
    );
  }

  Widget _page3(Size size, BuildContext context){

    final backgroundBox = Container(
      width: size.width * 0.8,
      height: size.height * 0.35,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.5, 1.0),
              end: FractionalOffset(1.0, 0.5),
              colors: [
                Color.fromRGBO(25, 91, 145, 1),
                Color.fromRGBO(3, 58, 102, 1)
              ]),
          borderRadius: BorderRadius.all(Radius.circular(100.0))),
    );

    return Column(
      children:[ 
        SizedBox(height: 100,),
        Stack(
          children: [
            backgroundBox,
            Hero(
              tag: "hader-login.webp",
              child: Image(image: AssetImage("assets/img/header-login.webp"), width: size.width* 0.8,)
            ),
          ],
        ),
        SizedBox(height: 80,),
        Text("Experiencias de realidad virtual", style: TextStyle(color: Color.fromRGBO(244, 131, 25, 1), fontSize: 25, fontWeight: FontWeight.bold),),
        SizedBox(height: 19,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Text("Diseñadas de una manera inmersiva y desarrolladas específicamente para tener un aprendizaje efectivo", style: TextStyle(fontSize: 20, color:  Color.fromRGBO(25, 91, 145, 1)), textAlign: TextAlign.center,)),
        _buttomOptions(2, "Comenzar", size, context)
      ],
    );
  }

  Widget _buttomOptions(int currentPage, String buttonText, Size size, BuildContext context) {
    return Column(children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              width: (currentPage == 0) ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 131, 25, 1),
                borderRadius: BorderRadius.circular(15)
              ),
            ),
            SizedBox(width: 3,),
            Container(
              width: (currentPage == 1) ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 131, 25, 1),
                borderRadius: BorderRadius.circular(15)
              ),
            ),
            SizedBox(width: 3,),
            Container(
              width: (currentPage == 2) ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: Color.fromRGBO(244, 131, 25, 1),
                borderRadius: BorderRadius.circular(15)
              ),
            )
          ],),
          SizedBox(height: 10,),
          CerevroButton(
            text: buttonText,
            color: Color.fromRGBO(25, 91, 145, 1),
            width: size.width * 0.9,
            execute: () => _changeCurrentPage(currentPage, context)),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () => {Navigator.of(context).pushNamed(LoginPage.tag)},
            child: Text("Omitir", style: TextStyle(decoration: TextDecoration.underline, fontSize: 20, color:  Color.fromRGBO(244, 131, 25, 1),)))  
    ]);
  }

  _changeCurrentPage(int currentPage, context){
    if(currentPage == 2){
      Navigator.of(context).pushNamed(LoginPage.tag);
    }else{
      _pageController.animateToPage(currentPage + 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}