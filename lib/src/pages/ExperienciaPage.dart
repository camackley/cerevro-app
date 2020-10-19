import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:cerevro_app/src/models/Experience.dart';
import 'package:cerevro_app/src/models/Learning.dart';
import 'package:cerevro_app/src/providers/Provider.dart';

class ExperiencePage extends StatefulWidget {
  static String tag = "experience-page";

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  
  IconData iconLike = Icons.favorite_border;
  List<Learning>  learnings = new List<Learning>();
  
  final _provider = Provider();

  bool _loading = false;
  bool _isWeiting = false;

  /* Download Task */
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Experience experience = ModalRoute.of(context).settings.arguments;
    _provider.getLearnings(experience.uid);

    return experienceResume(experience, size, context);
}

  Widget  experienceResume(Experience experience, Size size, BuildContext context){
        return Scaffold(
      backgroundColor: Color.fromRGBO(14, 68, 123, 1.0),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Stack(
          children: [
            FadeInImage(
                  placeholder: AssetImage("assets/gif/loading.gif"),
                  image: NetworkImage(experience.miniature),
                  fadeInDuration: Duration(milliseconds: 200),
                  height: size.height *0.4,
                  fit: BoxFit.cover
            ),
            GestureDetector(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: Svg(
                              "assets/icons/play_experience.svg", 
                              height: (size.height * 0.2).round(),
                              width: (size.width * 0.3).round()), 
                              color: Colors.white,
                      )
                    ],
                  ),
                ],
              ),
              onTap: (){
                Provider().lanzarUrl("https://cerevro.page.link/experience", context);
              }
            ),
            Container(
              height: size.height *0.1,
              child: AppBar(
                leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>{Navigator.of(context).pop()}),
                /* actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: ()=>{print("tap...")})], */
                backgroundColor: Colors.transparent,
              ),
            ),
            Column(
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
                      child: Column(
                        children: [
                          SizedBox(height: 30),
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
                          SizedBox(height: 10,),
                          /* _getLearningCards(size), */
                          SizedBox(height: 10,),
                        ],
                      ),
                    )
                  ),
                ],
              ),
          ],
        ),
      )
    );
  
  }

  Widget _getLearningCards(Size size) {
    return StreamBuilder(
      stream: _provider.learningStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor:  Colors.black,
            )
          );
        }else{
          return Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      elevation: 5.0,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(right: 10),
                        leading: FadeInImage(
                          placeholder: AssetImage("assets/gif/loading.gif"),
                          image: NetworkImage(snapshot.data[index].miniature),
                          fadeInDuration: Duration(milliseconds: 200),
                          width: 80,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].summary, style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 10))),
                        trailing: Icon(Icons.play_circle_filled, color: Color.fromRGBO(25, 91, 145, 1),),
                      ),
                  ),
                  onTap: ()=>{_showInstructions(context, size)},
                );
              },
              itemCount: snapshot.data.length,
            ),
          );
        }
      },
    );
  }

  void _sendLike(Experience experience, bool isPositive) async {
    await Firestore.instance
        .document('experiences/${experience.uid}')
        .get()
        .then((value) {
          experience = new Experience.fromDocumentSnapshot(value);
          int newLikes = (isPositive) ? experience.likes +1 : experience.likes-1;
          Firestore.instance
            .collection("experiences")
            .document(experience.uid)
            .updateData({"likes": newLikes});
        });
  }

  String _getDifferentTime(var creatioDate){
    final now = DateTime.now();
    if(now.difference(creatioDate).inHours < 24){
      return "hace ${(now.difference(creatioDate).inHours).toInt()} horas";
    }else if(now.difference(creatioDate).inDays>30 && now.difference(creatioDate).inDays<360){
        return "hace ${now.difference(creatioDate).inDays ~/ 30} meses";
    }else if(now.difference(creatioDate).inDays<30){
      return "hace ${(now.difference(creatioDate).inDays).toInt()} dias";
    }else{
      int meses =(now.difference(creatioDate).inDays / 30).round();
      return "Hace ${(meses / 12).round()} años";
    }
  }

  _showInstructions(BuildContext context, Size size) {
    _isWeiting = true;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text("Coloca el teléfono en el visor para comenzar", style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
            content: Container(
              height: size.height * 0.3,
              child: Column(
                children: [
                   Container(
                     child: Image(
                       image: Svg(
                          "assets/icons/simplevr.svg", 
                          height: (size.height * 0.2).round(),
                          width: (size.width * 0.3).round(),),
                        color: Color.fromRGBO(244, 131, 25, 1.0),),
                   ), 
                  Text("No te olvides de activar la rotación de pantalla", style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                ],
              ),
            ),
          );
        }
        );
  }
}