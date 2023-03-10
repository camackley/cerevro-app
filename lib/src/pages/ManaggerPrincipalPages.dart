import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:cerevro_app/library/BottomNavyBar.dart';
import 'package:cerevro_app/src/models/Topic.dart';
import 'package:cerevro_app/src/pages/ProfilePage.dart';
import 'package:cerevro_app/src/pages/SearchPage.dart';
import 'package:cerevro_app/src/providers/Provider.dart';
import 'package:cerevro_app/src/components/CerevroInputField.dart';

import 'HomePage.dart';

class ManaggerPrincipalPages extends StatefulWidget {
  static String tag = "managger-pricipal-pages";

  @override
  _ManaggerPrincipalPagesState createState() => _ManaggerPrincipalPagesState();
}

class _ManaggerPrincipalPagesState extends State<ManaggerPrincipalPages> {
  
  Future<dynamic> resUser;
  List<Topic> topics = new List<Topic>();

  PageController pageController;
  int _selectIndex = 0;

  final studentProvider = new Provider();

  CerevroInputInputController searchController = CerevroInputInputController();


  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 58, 102, 1),
      body: PageView(
        controller: pageController,
        children: [
          HomePage(),
          SearchPage(),
          ProfilePage(),
        ],
        onPageChanged: (index) {
          setState(() => _selectIndex = index);
        },
      ),
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          Navigator.of(context).pushNamed(deepLink.path);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
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
        pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
      })
    );
  }
}