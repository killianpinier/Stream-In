import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  DocumentReference ref;
  String uid;
  String pseudo;
  String imageUrl;
  String description;
  int totalViews;
  bool showContact;
  int phone;
  String email;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> musicGenre;


  User(DocumentSnapshot snapshot){
    ref = snapshot.reference;
    Map<String, dynamic> map = snapshot.data;
    uid = map["uid"];
    pseudo = map["pseudo"];
    imageUrl = map["imageUrl"];
    description = map["description"];
    totalViews = map["totalViews"];
    showContact = map["showContact"];
    email = map["email"];
    phone = map["phone"];
    followers = map["followers"];
    following = map["following"];
    musicGenre = map["musicGenre"];
  }
//  User(Map<String, dynamic> map){
//    ref = map["ref"];
//    uid = map["uid"];
//    pseudo = map["pseudo"];
//    imageUrl = map["imageUrl"];
//    followers = map["followers"];
//    following = map["following"];
//    musicGenre = map["musicGenre"];
//  }
}