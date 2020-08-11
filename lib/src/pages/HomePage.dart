import 'dart:io';

import 'package:cerevro_app/src/models/Student.dart';
import 'package:cerevro_app/src/providers/StudentProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class HomePage extends StatefulWidget {
  static String tag = "home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final studentProvider  = new StudentProvider();

  _HomePageState(){

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  _body(context, size);
  }

  Widget _body(BuildContext context, Size size) {
    studentProvider.getCurrentStudent();
    return StreamBuilder(
      stream: studentProvider.studentStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            )
          );
        }else{
          return  Container(
            color: Color.fromRGBO(14, 68, 123, 1.0),
            child: Column(
                children: [
                  _getAppBar(snapshot.data),
                   Container(
                    height: size.height * 0.81,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
                    ),
                    child: Column(
                      children: [
                      SizedBox(height: 30,),
                      _getCategorys(context, size),
                      _getContent(context, size),
                      ],
                    )
                  )
                ],
            ),
          );
        }
      }
    );
  }

  Widget _getAppBar(Student student){
    return AppBar(
      elevation: 0.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          Text("Bienvenido"),
          Text(student.name, style: TextStyle(fontSize: 25, color: Colors.white)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            child: Icon(Icons.notifications, color: Colors.white, size: 30.0,),
            onTap: () => print("Hola..."),
            ),
          )
        ],
      );
  }

  Widget _getCategorys(BuildContext context, Size size){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            Row(
              children: [
                _categoryCard(Color.fromRGBO(247, 170, 111, 1), "assets/icons/positive-charges.svg", "Sociales", size),
                SizedBox(width: size.width * 0.1),
                _categoryCard(Color.fromRGBO(87, 176, 255, 1), "assets/icons/speed.svg", "Fisica", size),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                _categoryCard(Color.fromRGBO(128, 217, 161, 1), "assets/icons/science.svg", "Biologia", size),
                SizedBox(width: size.width * 0.1,),
                _categoryCard(Color.fromRGBO(255, 97, 97, 1), "assets/icons/speak.svg", "Inglés", size), 
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                _categoryCard(Color.fromRGBO(220, 127, 255, 1), "assets/icons/lab.svg", "Quimica", size),
                SizedBox(width: size.width * 0.1,),
                _categoryCard(Color.fromRGBO(255, 186, 95, 1), "assets/icons/book.svg", "Historia", size), 
              ],
            )
          ]
        ),
      );
  }

  Widget _categoryCard(Color color, String assetsImage, String title, Size size) {
    return GestureDetector(
          child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(15.0),)
        ),
        height: size.height * 0.08,
        width: size.width * 0.4,
        child: ListTile(
          leading: Image(image: Svg(assetsImage, width: 65), color: Colors.white,),
          title: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
      onTap: () => {print("Query: $title")},
    );
  }

  Widget _getContent(BuildContext context, Size size) {
    return Container();
  }

  getNewsExperiences(){
    
  }
}