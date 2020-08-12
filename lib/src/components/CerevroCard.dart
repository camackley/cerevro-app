import 'package:cerevro_app/src/models/Experience.dart';
import 'package:cerevro_app/src/pages/ExperienciaPage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CerevroCard extends StatefulWidget{

  Experience experience;
  Size size;

  CerevroCard({
    @required this.experience,
    @required this.size
  });

  @override
  _CerevroCardState createState() => _CerevroCardState();
}

class _CerevroCardState extends State<CerevroCard> {
  @override
  Widget build(BuildContext context) {
    String differenteTime = _getDifferentTime( widget.experience.creationDate.toDate());
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: Container(
          width: widget.size.width * 0.8,
          child: Column(
            children: [
              FadeInImage(
                placeholder: AssetImage("assets/gif/loading.gif"),
                image: NetworkImage(widget.experience.miniature),
                fadeInDuration: Duration(milliseconds: 200),
                width: widget.size.width * 0.8,
                height: 100,
                fit: BoxFit.cover
              ),
              ListTile(
                title: Text(widget.experience.name, style: TextStyle(fontSize: 17),),
                subtitle: Text(
                  "${widget.experience.principalTag} · ${widget.experience.views} Vistas · $differenteTime",
                  style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12)),
                ),
                trailing: Text(widget.experience.duration),
              )
            ],
          ),
        )),
      onTap: () {
        Navigator.of(context).pushNamed(ExperiencePage.tag, arguments: widget.experience);
      },
    );
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