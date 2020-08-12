import 'package:cerevro_app/src/models/Experience.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExperiencePage extends StatefulWidget {
  static String tag = "experience-page";

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  
  IconData iconLike = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Experience experience = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 68, 123, 1.0),
      body: Stack(
        children: [
          FadeInImage(
                placeholder: AssetImage("assets/gif/loading.gif"),
                image: NetworkImage(experience.miniature),
                fadeInDuration: Duration(milliseconds: 200),
                height: size.height *0.4,
                fit: BoxFit.cover
          ),
          Container(
            height: size.height *0.1,
            child: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>{Navigator.of(context).pop()}),
              backgroundColor: Colors.transparent,
            ),
          ),
          GestureDetector(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.35,),
                Container(
                  height: size.height * 0.65,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
                  ),
                  child:Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                    child: ListView(
                      children: [
                        Text(experience.name, style: TextStyle(fontSize: 30.0)),
                        SizedBox(height: 20,),
                        Text(experience.summary, style: TextStyle(fontSize: 15.0)),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Publicado ${_getDifferentTime(experience.creationDate.toDate())}",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Duración promedio de ${experience.duration} min",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(width: size.width*0.1,),
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              child: Icon(iconLike, size: 30, color: Color.fromRGBO(25, 91, 145, 1),),
                              onPressed: (){
                                if(iconLike==Icons.favorite_border){
                                  _sendLike(experience, true);
                                  iconLike = Icons.favorite;
                                }else{
                                  _sendLike(experience, false);
                                  iconLike = Icons.favorite_border;
                                }
                                setState(() {});
                              }
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  void _sendLike(Experience experience, bool isPositive){
    Firestore.instance
      .collection("experiences")
      .document(experience.uid)
      .updateData({"likes": (isPositive) ? experience.likes+1 : experience.likes-1})
      .catchError((err) => {print(err)});
  }

  String _getDifferentTime(var creatioDate){
    final now = DateTime.now();
    if(now.difference(creatioDate).inHours < 24){
      return "hace ${now.difference(creatioDate).inHours} horas";
    }else if(now.difference(creatioDate).inDays>30 && now.difference(creatioDate).inDays<360){
        return "hace ${now.difference(creatioDate).inDays / 30} meses";
    }else if(now.difference(creatioDate).inDays<30){
      return "hace ${now.difference(creatioDate).inDays} dias";
    }else{
      int meses =(now.difference(creatioDate).inDays / 30).round();
      return "Hace ${(meses / 12).round()} años";
    }

  }
}