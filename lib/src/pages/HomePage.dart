import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  static String tag = "home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ModalProgressHUD(inAsyncCall: _loading, child: _body(context, size));
  }

    Widget _body(BuildContext context, Size size) {
    
    return Container(
      height: double.infinity,
      width: size.width,
      decoration: BoxDecoration(  
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight:  Radius.circular(15.0))
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Row(
              children: [
                _categoryCard(Colors.amberAccent, "assets/icons/positive-charges.svg", "Hola", "cotegory", size),
                SizedBox(width: size.width * 0.1,),
                _categoryCard(Colors.amberAccent, "assets/icons/positive-charges.svg", "Hola", "cotegory", size),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _categoryCard(Color color, String assetsImage, String title, String category, Size size) {
    return GestureDetector(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.all(Radius.circular(15.0),)
        ),
        height: size.height * 0.08,
        width: size.width * 0.4,
        child: ListTile(
          /* leading: SvgPicture.string(assetsImage), */
          title: Text(title, style: TextStyle(fontSize: 25, color: Colors.white)),
        ),
      ),
      onTap: () => {print("Tap..")},
    );
  }
}