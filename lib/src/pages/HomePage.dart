import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:cerevro_app/src/components/CerevroCard.dart';
import 'package:cerevro_app/src/models/Experience.dart';
import 'package:cerevro_app/src/models/Student.dart';
import 'package:cerevro_app/src/providers/Provider.dart';

class HomePage extends StatefulWidget {
  static String tag = "home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final provider  = new Provider();
  List<Experience> experiencesNew = new List<Experience>();

  bool _loading = true;

  _HomePageState(){
    _getNewsExperiences();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ModalProgressHUD(
            inAsyncCall: _loading,
            child: SafeArea(child: _body(context, size)));
  }

  Widget _body(BuildContext context, Size size) {
    provider.getCurrentStudent();
    return StreamBuilder(
      stream: provider.studentStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            )
          );
        }else{
          return  Container(
            color: Color.fromRGBO(3, 58, 102, 1),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      SizedBox(height: 30,),
                      _getCategorys(context, size),
                      SizedBox(height: 20,),  
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Novedades", style: TextStyle(fontSize: 17),),
                      ),
                      _getContent(context, size),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 20.0),
                        child: Text("Mejor cálificadas", style: TextStyle(fontSize: 17),),
                      ),
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
        //TODO: Hacer logica de notificaciones
        /* Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            child: Icon(Icons.notifications, color: Colors.white, size: 30.0,),
            onTap: () {

            },
            ),
          ) */
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
        height: size.height * 0.07,
        width: size.width * 0.4,
        child: ListTile(
          leading: Image(image: Svg(assetsImage, width: 65), color: Colors.white,),
          title: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
      onTap: () {
        //TODO: Hacer filtro login
      },
    );
  }

  Widget _getContent(BuildContext context, Size size) {
    return Container(
      height: size.height * 0.25,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            return CerevroCard(experience: experiencesNew[index], cardWidth: size.width * 0.8);
          },
          itemCount: experiencesNew.length,
        )
    );
  }

  _getNewsExperiences(){
      Firestore.instance
        .collection("experiences")
        .orderBy("creation_date")
        .limit(20)
        .snapshots()
        .listen((collection) { 
          experiencesNew.clear();
          for(var item in collection.documents){
            Experience experience = new Experience.fromDocumentSnapshot(item);
            experiencesNew.add(experience);
          }
          setState(() {
            _loading = false;
          });
        });  
  }

}