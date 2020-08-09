import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils{
  FirebaseUtils._privateConstructor();
  static final FirebaseUtils _instance = FirebaseUtils._privateConstructor();
  
  factory FirebaseUtils(){
    return _instance;
  }
  
  final _firestoreInstance = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  void resetPassword(email) async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<dynamic> create(String collection, data) async {
    var doc = await _firestoreInstance.collection(collection).add(data);
    return  doc.documentID;
  }

  void read(String collection, [Map where]){
    if(where!=null){
      switch(where["condition"]){
        
        case "==":
        _firestoreInstance
          .collection(collection)
          .where(where["field"], isEqualTo: where["value"]);
        break;

        case ">":
        /* _firestoreInstance
          .collection(collection)
          .where(where["field"],  : where["value"]); */
      }
      
    }else{
      _firestoreInstance.collection(collection).getDocuments().then((querySnapshot) {
          return querySnapshot;
      });
    }
  }

  void update(String collection, dynamic data) async {
    _firestoreInstance.collection(collection)
                      .add(data)
                      .then((value) => {print(value.documentID)});  
  }

}