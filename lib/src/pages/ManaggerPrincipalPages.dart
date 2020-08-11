import 'package:cached_network_image/cached_network_image.dart';
import 'package:cerevro_app/library/BottomNavyBar.dart';
import 'package:cerevro_app/src/models/Topic.dart';
import 'package:cerevro_app/src/models/User.dart';
import 'package:cerevro_app/src/pages/ExperienciaPage.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';

import 'HomePage.dart';

class ManaggerPrincipalPages extends StatefulWidget {
  static String tag = "managger-pricipal-pages";

  @override
  _ManaggerPrincipalPagesState createState() => _ManaggerPrincipalPagesState();
}

class _ManaggerPrincipalPagesState extends State<ManaggerPrincipalPages> {
  
  Future<dynamic> resUser;
  List<Topic> topics = new List<Topic>();
  User student;

  PageController _pageController;
  int _selectIndex = 0;

  _ManaggerPrincipalPagesState(){
    _getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: _getAppBar(),
          body: PageView(
            controller: _pageController,
            children: [
              HomePage(),
              Container(),
              Container(),
            ],
            onPageChanged: (index) {
              setState(() => _selectIndex = index);
            },
          ),
          bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  AppBar _getAppBar(){
    var home = {
      "title": Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            student != null ? Text(student.name, style: TextStyle(fontSize: 28, color: Colors.white)) :
            CircularProgressIndicator(),
            Text("Buenas tardes"),
            SizedBox(height: 15,),
          ],
        ),
      "actions": Padding(
           padding: const EdgeInsets.only(right: 10.0),
           child: GestureDetector(
             child: Icon(Icons.notifications, color: Colors.white, size: 30.0,),
             onTap: () => print("Hola..."),
           ),
         )
    };

    var search = {

    };

    return AppBar(
        elevation: 0, 
        backgroundColor: Color.fromRGBO(14, 68, 123, 1.0),
        title: _selectIndex==0 ? home["title"] : Container(),
        actions: [
          _selectIndex==0 ? home["actions"] : Container()
        ],);
  }

  BottomNavyBar _getBottomNavigationBar(){
    return BottomNavyBar(
      backgroundColor: Color.fromRGBO(3, 58, 102, 1),
      selectedIndex: _selectIndex,
      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Explorar'),
          textAlign: TextAlign.center,
          activeColor: Color.fromRGBO(244, 131, 25, 1)
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.search),
          title: Text('Buscar'),
          textAlign: TextAlign.center,
          inactiveColor: Colors.white,
          activeColor: Color.fromRGBO(244, 131, 25, 1)
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Mi perfil'),
          textAlign: TextAlign.center,
          inactiveColor: Colors.white,
          activeColor: Color.fromRGBO(244, 131, 25, 1)
        ),
      ], 
      onItemSelected: (index) => setState((){
        _selectIndex = index;
        _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
      })
    );
  }

  _getCurrentUser(){
    final _firestoreInstance = Firestore.instance;

    resUser = FirebaseAuth.instance
        .currentUser()
        .then((currentUser) {
             _firestoreInstance
                .collection("students")
                .document(currentUser.uid)
                .snapshots()
                .listen((data) {
                    student = new User.fromDocumentSnapshot(data);
                    setState(() {});
              });
        })
        .catchError((error){
          Toast.show("Error al autenticarte", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginPage()), (_) => false);
        });
  
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
                                  backgroundColor: Colors.orange,
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
              child: Text("Nuevos", style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:Colors.orange), textAlign: TextAlign.start)),
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
                                Colors.orange,
                                Colors.orange
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
              child: Text("Nuevos", style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color:Colors.orange), textAlign: TextAlign.start)),
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
                                Colors.orange,
                                Colors.orange
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
            title: Text("Opciones", style: TextStyle(color: Colors.orange)),
            content: Container(
              height: 55,
              child: Column(
                children: [         
                  FlatButton(
                  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.orange,
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

}