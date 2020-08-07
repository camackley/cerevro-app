import 'package:cached_network_image/cached_network_image.dart';
import 'package:cerevro_app/src/models/Experience.dart';
import 'package:cerevro_app/src/models/Topic.dart';
import 'package:cerevro_app/src/models/User.dart';
import 'package:cerevro_app/src/pages/WebViewPage.dart';
import 'package:cerevro_app/src/static/statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:stripe_native/stripe_native.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({Key key}) : super(key: key);
  static String tag = "experience-page";

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {

  Future<DocumentSnapshot> respExperience;
  Future<DocumentSnapshot> respUser;

  User usuario = new User();
  List<Experience> experiences = new List<Experience>();

  bool buy=false;

  _ExperiencePageState(){
    _getUserInfo();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Topic arguments = ModalRoute.of(context).settings.arguments;
    _getExperiences(arguments);
    buy = _getBuy(arguments);
    return Scaffold(
        body:FutureBuilder(
          future: respUser,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
           return Center(
             child: CircularProgressIndicator(
                backgroundColor: CerevroColors.accent),
           );
          }else{
            return _body(context, arguments);
          }})
    );
  }

  Widget _body(BuildContext context, Topic arguments) {
    /* Widget star = Icon(Icons.star_border); */
    final appBar= AppBar(
      elevation: 0,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      leading: 
        Container(
          margin: EdgeInsets.only(left: 10),

          child: FloatingActionButton(
            elevation: 3,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back_ios, color: CerevroColors.accent),
            onPressed: () => Navigator.of(context).pop(),
          ),
        )
    );

    final box = Container(
      width: 500,
      height: 300,
      child:CachedNetworkImage(
        imageUrl: arguments.image,
        placeholder: (context, url) => Center(
        child: new CircularProgressIndicator(
          backgroundColor: CerevroColors.accent,
        ),
      ),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
      decoration: BoxDecoration(
      color: Colors.black38,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0), bottomLeft: Radius.circular(20.0))),
    );
    final iconPlay = GestureDetector(child:Center(child: Container(
      margin: EdgeInsets.only(top: 30),
      width: 200,
      height: 200,
      child: Icon(Icons.play_circle_outline, size: 100, color: CerevroColors.accent,))), 
      onTap: (){
        _showMessage(context, "Falta un poco...", "Esta experiecnia aún no está disponible, pero no te preocupes te mantendremos informado");
        //Navigator.of(context).pushNamed(WebViewPage.tag, arguments:experiences[0].url);
      },);
    final card = Container(
      margin: EdgeInsets.only(top: 250, right: 30, left: 30),
      padding: EdgeInsets.symmetric(vertical:7),
      height: 87,
      child:  Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
        child: Center(child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SizedBox(
            height: 10,
          ),
          FittedBox(
            fit:BoxFit.fitWidth, 
            child: Text(arguments.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 20,
          ),
/*           FloatingActionButton(

            elevation: 2,
               shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                child: star,
                /* (buy)?Icon(favorito, color: Colors.white) : Icon(Icons.attach_money, color: Colors.white), */
                onPressed: (){
                  //_confirmMessage(context);
                  if(star == Icon(Icons.star_border)){
                    star=Icons.star;
                    _addStar(arguments);
                  }else{
                    star=Icons.star_border;
                  }
                  setState(() {});
                },
              ),     */         
        ],),),
      ),
    );
    
    return Column(
      children: [
        Stack(
          children: <Widget>[box, appBar, card],
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 20),
          alignment: Alignment.bottomLeft,
          child: Text("Experiencias", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
        ),
        FutureBuilder(
          future: respExperience,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
           return Center(
             child: CircularProgressIndicator(
                backgroundColor: CerevroColors.accent),
           );
          } else {
           return Container(
             child: Flexible(
               child: ListView.builder(
                itemCount: experiences.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                      child: ListTile(
                        title: FittedBox(child:Text(experiences[index].title, style: TextStyle(fontSize: 30),)),
                        leading: CachedNetworkImage(
                            imageUrl: experiences[index].image,
                              placeholder: (context, url) => Center(
                                child: new CircularProgressIndicator(
                                  backgroundColor: CerevroColors.accent,
                                ),
                              ),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                        trailing: FlatButton(
                           child: Icon(Icons.play_circle_filled, color: CerevroColors.accent),
                          onPressed:() async {
                            final url = experiences[index].url;
                            if (await canLaunch(url)) {
                                await launch(url);
                            } else {
                            throw 'Could not launch $url';
                            }
                            //_showMessage(context, "Falta ún poco...", "Esta experiencia aún no está disponible :( Pero no te preocupes te estaremos informando");
                            //Navigator.of(context).pushNamed(WebViewPage.tag, arguments:experiences[index].url);
                          },
                        ),
                      )
                    ));
                }
               )
             )
           );
         }})
      ],
    );
  }

  void _getExperiences(Topic argumets) async {
    
    if(experiences.length==0){
          final _firestoreInstance = Firestore.instance;
    int i=0;

    for (var item in argumets.experiencias) {
      if(i==(argumets.experiencias.length-1)){
        i++;
        respExperience =  _firestoreInstance.collection(BD.experiences).document(item).get();
        respExperience.then((response) {
          Experience expe = Experience.fromJson(response.data);
          experiences.add(expe);
          setState(() {});
        });
      }else{
        i++;
        var doc = await _firestoreInstance.collection(BD.experiences).document(item).get();
        Experience expe = Experience.fromJson(doc.data);
        experiences.add(expe);
      }
    }
    }
  }

  void _getUserInfo(){
    final _firestoreInstance = Firestore.instance;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.currentUser().then((_) {
      respUser = _firestoreInstance.collection(BD.users).document(_.uid).get();
      respUser.then((user) {
        usuario = User.fromJson(user.data);
        setState(() {});
      });
    });
  }

  bool _getBuy(Topic arguments) {
    if(usuario.topics==null){
      return false;
    }
    List topics = usuario.topics;
    for (var topic in topics){
      if(topic==arguments.uid){
        return true;
      }
    }
    return false;
  }

  void _addStar(Topic argument) {
    Map data ={
     "stars": argument.stars+1
    };

    final _firestoreInstance = Firestore.instance;
    _firestoreInstance.collection(BD.topics).document(argument.uid).updateData(data);
  }

  Widget _confirmMessage(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Comprar esta ventura", style: TextStyle(color: CerevroColors.accent)),
            content: Text("Estas a un paso de disfrutar esta ventura: \$1.00"),
            actions: <Widget>[
              FlatButton(
                child: Text("Comprar ahora",
                    style: TextStyle(color: CerevroColors.accent)),
                onPressed: () { 
                  Navigator.of(context).pop();
                }
              )
            ],
          );
        });

    return Container();
  }

    Widget _showMessage(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title, style: TextStyle(color: CerevroColors.accent)),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar",
                    style: TextStyle(color: CerevroColors.accent)),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });

    return Container();
  }

  void doPayment()async{
    //await payment;
    //const wasCharged = await AppAPI.charge(token, amount);
    //StripeNative.confirmPayment(wasCharged);
  }

/*   Future<String> get payment async {
    const receipt = <String, double>{"Experiencia": 1.00};
    var aReceipt = Receipt(receipt, "Cerevro");
    return await StripeNative.useReceiptNativePay(aReceipt);
  } */
}
