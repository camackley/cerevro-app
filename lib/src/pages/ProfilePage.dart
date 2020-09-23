import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/models/Student.dart';
import 'package:cerevro_app/src/providers/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final provider = new Provider();

  @override
  Widget build(BuildContext context) {
    provider.getCurrentStudent();
    final size = MediaQuery.of(context).size;

    return StreamBuilder<Object>(
      stream: provider.studentStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          final Student student = snapshot.data;
          return SafeArea(
            child: Container(
              color: Color.fromRGBO(3, 58, 102, 1),
              child: Stack(
                children: <Widget>[
                  _getUserInfo(context, size, student),
                  _getAppBar(context, size),
                  _getDetails(context, size),
                  _getTotalPoint(size, student),
                  _getUserHistory(size, student)
                ],
              ),
            ),
          );
        }
      }
    );
  }

  Widget _getUserInfo(BuildContext context, Size size, Student student) {
    return Container(
      width: size.width,
      height: size.height * 0.4,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.1, horizontal: size.width*0.05),
      child: Row(
        children: [
         ClipRRect( 
           borderRadius: BorderRadius.all(Radius.circular(200)),
           child: FadeInImage(
              placeholder: AssetImage("assets/gif/loading.gif"),
              image: NetworkImage(student.avatarUrl),
              fadeInDuration: Duration(milliseconds: 200),
              width: 150,
              height: 150,
              imageErrorBuilder: (context, object, stackTrace){
                return Icon(Icons.account_circle, color: Color.fromRGBO(234, 126, 24, 1), size: 170,);
              },
              fit: BoxFit.cover
            ),
         ),
         SizedBox(
           width: size.width * 0.05,
         ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(student.name, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
             Text("Estudiante", style: TextStyle(color: Colors.white, fontSize: 17)),
             Text(student.gradeName, style: TextStyle(color: Colors.white, fontSize: 17))
           ],
         ),
        ],
      ),
    );
  }

  Widget _getTotalPoint(Size size, Student student) {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.32, left: size.width * 0.1, right: size.width *0.1),
      height: size.height * 0.2,
      width: size.width * 0.8,
      child: Card(
        color: Color.fromRGBO(244, 131, 25, 1),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Has acomulado", style: TextStyle(color: Colors.white, fontSize: 17),),
              SizedBox(
                height: 20,
              ),
              Text("${student.totalPoints.toString()} pts.", style: TextStyle(color: Colors.white, fontSize: 30)),
              SizedBox(
                height: 20,
              ),
              Text("Eres genial 🚀", style: TextStyle(color: Colors.white, fontSize: 17),),
            ],
          ),
        ),
      )
    );
  }

  Widget _getDetails(BuildContext context, Size size) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.4,),
        Container(
          height: size.height * 0.4868,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
          ),
        ),
      ],
    );
  }

  Widget _getUserHistory(Size size, Student student) {
    provider.getStudentResume(student);
    return StreamBuilder(
      stream: provider.historyExperienceStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(snapshot.data.length == 0){
          return Padding(
            padding: null,
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.6),
                Text("Aún no has participado en ninguna experiencia, prueba una hora 🥽")
              ],
            ),
          );
        }else{
          var data = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.55,),
                Text("Tú historial de puntos", style: TextStyle(fontSize: 25),),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index){
                      var date = data[index].date.toDate();
                      date = "${date.day}/${date.month}/${date.year}";
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 2,
                            color: Color.fromRGBO(25, 91, 145, 1)
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        child:ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          leading: Text("${data[index].points} pts", style: TextStyle(fontSize: 17),),
                          title: Text("${data[index].title}", style: TextStyle(fontSize: 18),),
                          subtitle: Text(date),
                        )
                      );
                    },
                    itemCount: data.length,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _getAppBar(BuildContext context, Size size) {
    return Container(
      height: size.height * 0.1,
      child: AppBar(
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: (){_showOptions(context);})
        ],
        backgroundColor: Colors.transparent
      ),
    );
  }
 
  _showOptions(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 15.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: Container(     
                child: CerevroButton(
                  text: "Cerrar sessión", 
                  color: Color.fromRGBO(25, 91, 145, 1), 
                  width: double.infinity,
                  execute: (){
                    Navigator.of(context).pop();
                    _signOut(context);
                  })
            ),
          );
        });
  }

  Future _signOut(BuildContext context)  async{
    await FirebaseAuth.instance.signOut();
    Toast.show("Te esperamos ver pronto", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginPage()), (_) => false);
  }
}