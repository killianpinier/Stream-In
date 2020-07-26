import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  DocumentReference ref;
  String uid;
  String documentId;
  String musicFile;
  String coverImage;
  String title;
  bool isAudio;
  int views;
  int date;
  String description;
  List<dynamic> likes;
  List<dynamic> comments;

  Post(DocumentSnapshot snapshot){
    ref = snapshot.reference;
    documentId = snapshot.documentID;
    Map<String, dynamic> map = snapshot.data;
    uid = map["uid"];
    coverImage = map["coverImageUrl"];
    musicFile = map["musicFileUrl"];
    title = map["title"];
    isAudio = map["isAudio"];
    date = map["date"];
    views = map["views"];
    description = map["description"];
    likes = map["likes"];
    comments = map["comments"];
  }
}