import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streamin/model/post.dart';
import 'package:streamin/services/date_conversion.dart';
import 'package:streamin/services/fire_services.dart';

class CreateNewAlbumPage extends StatefulWidget {
  @override
  _CreateNewAlbumPageState createState() => _CreateNewAlbumPageState();
}

class _CreateNewAlbumPageState extends State<CreateNewAlbumPage> {

  Color primaryColor = Color(0xFF00B97E);
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    setUpSub();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    sub.cancel();
    controller.dispose();
    super.dispose();
  }

  List<Post> posts = [];
  StreamSubscription sub;

  File imageTaken;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Créer un album", style: TextStyle(fontFamily: "Ariale", color: Colors.white, fontSize: 25.0),),
        centerTitle: true,
        actions: [
          FlatButton(onPressed: (){
            List<String> postRef = [];
            for(int i=0; i!= posts.length-1; i++){
              postRef.add(posts[i].documentId);
            }
            print(postRef);
            sentToFireBase(postRef);
          }, child: Text("Créer", style: TextStyle(fontFamily: "Ariale"),))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Ajoutez un titre", hintStyle: TextStyle(fontFamily: "Ariale"),
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
                      contentPadding: EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0)
                  ),
                ),
              ),
              InkWell(
                onTap: () => getImage(),
                child: imageTaken == null? Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.white,),
                  width: 200.0,
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 35.0),
                      Text("Image de couverture", style: TextStyle(fontFamily: "Ariale"),)
                    ],
                  ),
                ) : Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), image: DecorationImage(image: FileImage(imageTaken), fit: BoxFit.cover)),
                ),
              ),
              SizedBox(height: 10.0,),
              Text("Sélectionner vos musiques :", style: TextStyle(fontFamily: "Ariale", fontSize: 24.0), textAlign: TextAlign.center,),
              Container(
                height: posts.length*110.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index){
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.5), image: DecorationImage(image: posts[index].coverImage == null? AssetImage("assets/logoApp.png") : NetworkImage(posts[index].coverImage), fit: BoxFit.cover)),
                                    ),
                                    SizedBox(width: 10.0,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(posts[index].title, style: TextStyle(fontFamily: "Ariale", fontWeight: FontWeight.bold, fontSize: 19.0),),
                                        Text(DateConversion().myDate(posts[index].date), style: TextStyle(fontFamily: "Ariale",),)
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  // selected box
                                )
                              ],
                            )
                          ),
                        );
                      }
                  ),
              ),
            ],
          ),
      ),
    );
  }

  sentToFireBase(List<String> postId){
    FireServices().createAlbum(imageTaken, controller.text, postId);
  }

  setUpSub(){
    sub = FireServices().fireUser.document(meUid).snapshots().listen((datas){
      datas.reference.collection("posts").snapshots().listen((post) {
        setState(() {
          posts = getPosts(post.documents);
        });
      });
    });
  }

  List<Post> getPosts(List<DocumentSnapshot> postDocs) {
    List<Post> myList = posts;
    postDocs.forEach((p) {
      Post post = Post(p);
      print(post.musicFile);
      if(myList.every((p) => p.documentId != post.documentId)) {
        myList.add(post);
      }else{
        Post toBeChanged = myList.singleWhere((p) => p.documentId == post.documentId);
        myList.remove(toBeChanged);
        myList.add(post);
      }
    });
    myList.sort((a, b) => b.date.compareTo(a.date));
    return myList;
  }

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      imageTaken = File(pickedFile.path);
      print(imageTaken);
    });
  }
}


//SimpleDialog(
//contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//backgroundColor: Colors.grey[100],
//shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//title: Text("Créer un nouvel album", style: TextStyle(fontFamily: "Ariale"), textAlign: TextAlign.center,),
//children: [
//InkWell(
//onTap: () async{
//File image;
//final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 30);
//setState(() {
//image = File(pickedFile.path);
//print(imageTaken);
//});
//},
//child: imageTaken == null?Container(
//color: Colors.white,
//height: 150.0,
//width: 150.0,
//child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
//children: [
//Icon(Icons.add, size: 35.0),
//Text("Image de couverture", style: TextStyle(fontFamily: "Ariale"),)
//],
//),
//): Container(
//height: 150.0,
//width: 150.0,
//decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), image: DecorationImage(image: FileImage(imageTaken), fit: BoxFit.cover)),
//),
//),
//TextField(
//decoration: InputDecoration(
//hintText: "Ajoutez un titre",
//filled: true,
//fillColor: Colors.white,
//focusColor: Colors.white,
//border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0),
//borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
//contentPadding: EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0)
//),
//)
//],
//);