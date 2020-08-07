import 'package:cached_network_image/cached_network_image.dart';
import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/models/Topic.dart';
import 'package:cerevro_app/src/pages/ExperienciaPage.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/static/statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  static String tag = "home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Future<dynamic> respTopics;
  List<Topic> topics = new List<Topic>();

  _HomePageState(){
    _getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, title: Text(Texts.tilte, style: TextStyle(fontSize: 35, color: CerevroColors.accent),),
       actions: [
         GestureDetector(
           child: Icon(Icons.more_vert, color: CerevroColors.accent, size: 25.0,),
           onTap: () => _showOptions(context),
         )
       ],),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return FutureBuilder(
      future: respTopics,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: CerevroColors.accent),
          );
        } else {
          return Container(
            width: double.infinity,
            child:  Column(
              children: [
                _swiper(context),
                _new(context),
                _moreSelected(context),
              ],
            ),
          );
        }});
  }

  Widget _swiper(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                 return Card(
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                              imageUrl: topics[index].image,
                              placeholder: (context, url) => Center(
                                child: new CircularProgressIndicator(
                                  backgroundColor: CerevroColors.accent,
                                ),
                              ),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                        Container(
                          color: Color.fromRGBO(0, 0, 0, 0.4)
                        ),
                        Column(
                        mainAxisAlignment :MainAxisAlignment.center,
                        children: [
                        Container(
                          child: Text(topics[index].title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
                        ),
                        Container(
                          width: 200,
                          child: Text(topics[index].resume, style: TextStyle(color: Colors.white, fontSize: 12,), textAlign: TextAlign.center,)
                        ),
                        /* FlatButton(
                          child: Buton(text: "Ver ahora", width: 150, height: 30),
                          onPressed: () => {
                            Navigator.of(context).pushNamed(ExperiencePage.tag, arguments: topics[index])
                          },
                        ) */
                        ],)
                      ],
                    ),    
                  );
              },
              itemCount: 1,
              control: SwiperControl(
                iconNext: null,
                iconPrevious: null,
              ),
              duration: 3,
              autoplay: true,
      )
    );
  }

  Widget _new(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.centerLeft,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("Nuevos", style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:CerevroColors.accent), textAlign: TextAlign.start)),
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 250,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      color: Colors.black,
                      child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(topics[index].image),
                          ),
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                            borderRadius: BorderRadius.circular(15) ),
                        ),
                      Container(
                          margin: EdgeInsets.only(top: 125, left: 10),
                          child: Text(topics[index].title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                        ),
                      Center(
                          child: FlatButton(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(Icons.play_arrow,color: Colors.white),
                              decoration: BoxDecoration(
                              gradient: LinearGradient(
                              begin: FractionalOffset(0.5, 1.0),
                              end: FractionalOffset(0.0, 0.0),
                              colors: [
                                CerevroColors.accent,
                                CerevroColors.accent
                              ]),
                              borderRadius: BorderRadius.circular(100.0)),
                            ),
                            onPressed: () => {
                              Navigator.of(context).pushNamed(ExperiencePage.tag, arguments: topics[index])
                            },
                          ),
                        )
                      ]
                    ),  
                    ),
                  );
           },
          ),
            ),
          ],
      )
    );
  }

  Widget _moreSelected(BuildContext context){
   return Container(
      height: 200,
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.centerLeft,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("Nuevos", style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:CerevroColors.accent), textAlign: TextAlign.start)),
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 250,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      color: Colors.black,
                      child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(topics[index].image),
                          ),
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                            borderRadius: BorderRadius.circular(15) ),
                        ),
                      Container(
                          margin: EdgeInsets.only(top: 125, left: 10),
                          child: Text(topics[index].title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                        ),
                      Center(
                          child: FlatButton(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(Icons.play_arrow,color: Colors.white),
                              decoration: BoxDecoration(
                              gradient: LinearGradient(
                              begin: FractionalOffset(0.5, 1.0),
                              end: FractionalOffset(0.0, 0.0),
                              colors: [
                                CerevroColors.accent,
                                CerevroColors.accent
                              ]),
                              borderRadius: BorderRadius.circular(100.0)),
                            ),
                            onPressed: () => {
                              Navigator.of(context).pushNamed(ExperiencePage.tag, arguments: topics[index])
                            },
                          ),
                        )
                      ]
                    ),  
                    ),
                  );
           },
          ),
            ),
          ],
      )
    );
  }

  Widget _showOptions(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Opciones", style: TextStyle(color: CerevroColors.accent)),
            content: Container(
              height: 55,
              child: Column(
                children: [         
                  FlatButton(
                  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  color: CerevroColors.accent,
                  child: Text("Cerrar sesión",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _signOut(context);
                  },
                )],
              ),
            ),
          );
        });

    return Container();
  }

  Future _signOut(BuildContext context)  async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginPage()), (_) => false);
  }

  void _getTopics() {
    final _firestoreInstance = Firestore.instance;
      respTopics=_firestoreInstance.collection(BD.topics).getDocuments();
      respTopics.then((response) {
        for (var data in response.documents) {
         if (data != null) {
          Topic topic = new Topic.fromJson(data.data);
          topics.add(topic);
        }
      }
    });
  }
}