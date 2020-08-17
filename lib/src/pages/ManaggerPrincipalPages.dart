import 'package:cerevro_app/library/BottomNavyBar.dart';
import 'package:cerevro_app/src/components/CerevroInputField.dart';
import 'package:cerevro_app/src/models/Topic.dart';
import 'package:cerevro_app/src/pages/LoginPage.dart';
import 'package:cerevro_app/src/pages/SearchPage.dart';
import 'package:cerevro_app/src/providers/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class ManaggerPrincipalPages extends StatefulWidget {
  static String tag = "managger-pricipal-pages";

  @override
  _ManaggerPrincipalPagesState createState() => _ManaggerPrincipalPagesState();
}

class _ManaggerPrincipalPagesState extends State<ManaggerPrincipalPages> {
  
  Future<dynamic> resUser;
  List<Topic> topics = new List<Topic>();

  PageController _pageController;
  int _selectIndex = 0;

  final studentProvider = new Provider();

  CerevroInputInputController searchController = CerevroInputInputController();


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
      body: PageView(
        controller: _pageController,
        children: [
          HomePage(),
          SearchPage(),
          Container(),
        ],
        onPageChanged: (index) {
          setState(() => _selectIndex = index);
        },
      ),
      bottomNavigationBar: _getBottomNavigationBar(),
    );
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

  Future _signOut(BuildContext context)  async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginPage()), (_) => false);
  }

}