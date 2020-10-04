import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cerevro_app/src/components/CerevroButton.dart';
import 'package:cerevro_app/src/components/CerevroCard.dart';
import 'package:cerevro_app/src/components/CerevroInputField.dart';
import 'package:cerevro_app/src/components/CerevroFeature.dart';
import 'package:cerevro_app/src/providers/Provider.dart';

class SearchPage extends StatefulWidget {
  static String tag = "search-page";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  CerevroInputInputController searchController = new CerevroInputInputController();
  final provider = new Provider();

  List<dynamic> orderQuery = new List<dynamic>();
  List<dynamic> topicQuery = new List<dynamic>();
  bool _showFilter = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var category = ModalRoute.of(context).settings.arguments;
    (category!=null) ? topicQuery.add(category) : category ="";

    return SafeArea(
        child: Container(
          color: Color.fromRGBO(3, 58, 102, 1),
          child: Stack(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height*0.1,
              color: Color.fromRGBO(3, 58, 102, 1),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: size.width*0.1),
                    child: CerevroInputField(
                      hintText: "Buscar...",
                      editingController: searchController.editingController,
                      isError: searchController.isError, 
                      textInputType: TextInputType.text,
                      onChange: _search,
                    ),
                  ),
                trailing: IconButton(
                    icon:  Icon(Icons.filter_list, color: Colors.white, size: 30,),
                    onPressed: (){
                      _showFilter = true;
                      setState(() {});
                    }
                ) 
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height*0.1,
                ),
                Container(
                  width: size.width,
                  height: size.height*0.786,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
                  ),
                  padding: EdgeInsetsDirectional.only(top: 20),
                  child: _getResults(context, size),
                )
              ],
            ),
            Visibility(
              child: moreFilter(context, size),
              visible: _showFilter,
            ),
          ],
      ),
        ),
    );
  }

  Widget _getResults(BuildContext context, Size size) {
    return StreamBuilder(
      stream: provider.searchExperienceStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          _search("");
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(3, 58, 102, 1),
            ),
          );
        }else{  
          if(snapshot.data.length == 0){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: size.width*0.15, vertical: size.height * 0.1),
              child: Center(
                child: Column(
                  children: [
                    Image(image: AssetImage("assets/img/send_request.webp"), width: size.width* 0.8,),
                    SizedBox(height: 20.0,),
                    Text("No lo encontramos 😢, envianos una sugerencia y construiremos algo incereible 🚀", style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 15,))),
                    SizedBox(height: 20.0,),
                    CerevroButton(
                      text: "Enviar sugerencia", 
                      color: Color.fromRGBO(244, 131, 25, 1),
                      width: size.width * 0.7,
                      execute: () {
                        provider.sendToWpp(searchController.editingController.text, context);
                      }
                    )
                  ],
                )
              ),
            );
          }else{
            return ListView.builder(
              itemBuilder: (BuildContext context, int index){
                return CerevroCard(experience: snapshot.data[index], cardWidth: size.width*0.9);
              },
              itemCount: snapshot.data.length,
            );
          }
        }
      }
    );
  }

  void _search(String word, [orderBy, categoryType]){
    var query = [word];
    if(orderBy != null && orderBy.length > 0){
      query.add(orderBy[0]);
    }else{
      query.add(null);
    }
    if(categoryType != null && categoryType.length > 0){
      query.add(categoryType[0]);
    }else{
      query.add(null);
    }
    provider.getSearch(query);
  }

  Widget moreFilter(BuildContext context, Size size){
    return Stack(
      children: <Widget>[
        GestureDetector(
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.3)
          ),
          onTap: () {
            _showFilter = false; 
            setState(() {});
          },
        ),
        Column(
          children: [
            SizedBox(
              height: size.height * 0.386,
            ),
            Container(
              width: size.width,
              height: size.height * 0.5,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filtrar", style: TextStyle(fontSize: 30.0)),
                      IconButton(icon:
                        Icon(
                          Icons.clear,
                          color: Color.fromRGBO(25, 91, 145, 1)), 
                          onPressed: (){
                            _showFilter = false; 
                            setState(() {});
                          },)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Ordenar por", style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CerevroFeature(
                        isSelected: (orderQuery.contains("creation_date")) ? true : false,
                        name: "Recientes",
                        queryExcute: (){
                          orderQuery.clear();
                          orderQuery.add("creation_date");
                          setState(() {});
                        },
                      ),
                      CerevroFeature(
                        isSelected: (orderQuery.contains("views")) ? true : false,
                        name: "Populares",
                        queryExcute: (){
                          orderQuery.clear();
                          orderQuery.add("views");
                          setState(() {});
                        },
                      ),
                      CerevroFeature(
                        isSelected: (orderQuery.contains("duration")) ? true : false,
                        name: "Tiempo",
                        queryExcute: (){
                          orderQuery.clear();
                          orderQuery.add("duration");
                          setState(() {});
                        },
                      ),
                    ],
                  )
                  ,SizedBox(height: 20,),
                  Text("Tema", style: TextStyle(fontSize: 20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CerevroFeature(
                        isSelected: (topicQuery.contains("sociales")) ? true : false,
                        name: "Sociales",
                        queryExcute: (){
                          topicQuery.clear();
                          topicQuery.add("sociales");
                          setState(() {});
                        },
                      ),
                      CerevroFeature(
                        isSelected: (topicQuery.contains("fisica")) ? true : false,
                        name: "Fisica",
                        queryExcute: (){
                          topicQuery.clear();
                          topicQuery.add("fisica");
                          setState(() {});
                        },
                      ),
                      CerevroFeature(
                        isSelected: (topicQuery.contains("biologia")) ? true : false,
                        name: "Biologia",
                        queryExcute: (){
                          topicQuery.clear();
                          topicQuery.add("biologia");
                          setState(() {});
                        },
                      ),
                      CerevroFeature(
                        isSelected: (topicQuery.contains("ingles")) ? true : false,
                        name: "Inglés",
                        queryExcute: (){
                          topicQuery.clear();
                          topicQuery.add("ingles");
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 35,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text("Limpiar todo", style: TextStyle(fontSize: 18.0, decoration: TextDecoration.underline),),
                        onTap: (){
                          topicQuery.clear();
                          orderQuery.clear();
                          _search(searchController.editingController.text);
                          setState(() {});
                        },
                      ),
                      CerevroButton(
                        text: "Aplicar",
                        color: Color.fromRGBO(25, 91, 145, 1), 
                        width: size.width * 0.35,
                        execute: (){  
                          _search(searchController.editingController.text, orderQuery, topicQuery);
                          setState(() {
                            _showFilter = false;
                          });
                        }
                      )
                    ],
                  )
                ]
              ),
            ),
          ],
        )
      ],
    );
  }

}