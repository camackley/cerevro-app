import 'package:cerevro_app/src/pages/ManaggerPrincipalPages.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/pages/WelcomeScrollPage.dart';
import 'package:cerevro_app/src/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final preferences = new UserPreferences();
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) async {
              if (currentUser == null){
                if(preferences.isFirstTime) {
                  preferences.isFirstTime = false;
                  Navigator.pushNamed(context, WelcomeScrollpage.tag);
                }else{
                  await Future.delayed(const Duration(milliseconds: 400));
                  Navigator.pushReplacementNamed(context, LoginPage.tag);                  
                }
              }else{
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                builder: (context) => ManaggerPrincipalPages()));
              }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* _createDB(); */
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 91, 145, 1),
      body: Center(
        child: Container(
          child: Text("Bienvenido!", style: TextStyle(color: Colors.white, fontSize: 40),),)
        )
      );
  }

  void _createDB() {
    var uuid = Uuid();
    final _firestoreInstance = Firestore.instance; 

    /* List exper = new List();
    for(int i=0; i<101; i++){
      var uid = uuid.v4();
      Map<String, dynamic> data = {   
        "uid": uid,
        "image": "https://picsum.photos/400/300",
        "resume": "Aut omnis tenetur quidem ea accusamus odio.Ut iure ea.",
        "title": "Prueba $i",
        "url": "https://youtu.be/hNAbQYU0wpg",
      };
      _firestoreInstance.collection(BD.experiences).document(uid).setData(data);
      exper.add(uid);
      if(exper.length==5){
        var id = uuid.v4();
        Map<String, dynamic> data = {   
          "uid": id,
          "image": "https://picsum.photos/400/300",
          "resume": "Aut omnis tenetur quidem ea accusamus odio.Ut iure ea.",
          "title": "Topic $i",
          "stars": i,
          "experiences": exper
        };
        _firestoreInstance.collection(BD.topics).document(id).setData(data);
        exper.clear();
      }
    } */
    var id = uuid.v4();
    final topicsImage = [
      "https://image.freepik.com/vector-gratis/sistema-solar-infografia-eje-planetas_23-2148400561.jpg",
      "https://image.freepik.com/vector-gratis/ilustracion-mundo-dinosaurios-salvajes_1284-23622.jpg",
      "https://image.freepik.com/foto-gratis/figura-medica-masculina-3d-que-muestra-escapula-hombro_1048-8833.jpg",
      "https://image.freepik.com/vector-gratis/paisaje-submarino-animales-marinos_107791-623.jpg",
      "https://image.freepik.com/vector-gratis/ilustracion-grafica-ubicacion-mapa-continente-mundial_53876-6448.jpg"
    ];

    final experienceImage=[
      [
        "https://image.freepik.com/vector-gratis/sistema-planeta-explorando-planetas-aterrizando-ilustracion-banner-personaje-dibujos-animados-jupiter-saturno-urano-neptuno_101903-1682.jpg",
        "https://image.freepik.com/vector-gratis/planetas-espacio-exterior-satelites-meteoritos-ilustracion_33099-2352.jpg",
        "https://image.freepik.com/vector-gratis/astronauta-escena-alienigena_1308-32590.jpg",
        "https://image.freepik.com/vector-gratis/coleccion-planeta-dibujado-mano_23-2148319859.jpg"
      ],[
        ""
      ]];
  }
}