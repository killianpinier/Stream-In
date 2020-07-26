import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:streamin/views/pages/newPostPage/customPostPage.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  Color primaryColor = Color(0xFF00B97E);

  TextEditingController titleController;
  final picker = ImagePicker();
  File music;
  File image;
  bool isAudio = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Text("Nouveau post",style: TextStyle( color: Colors.white, fontFamily: "Ariale"),),
        actions: [
          InkWell(
            onTap: () => music != null && titleController.text != null && titleController.text != ""?
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomPostPage(music: music, title: titleController.text,isAudio: isAudio, coverImage: image == null? null : image,))) : alertDialog(),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(child: Text("Suivant", style: TextStyle(color: Colors.black, fontFamily: "Ariale"),)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            music == null?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  musicSelect("Audio", Icons.music_note, getAudio),
                  Text("ou", style: TextStyle(color: Colors.white, fontSize: 25.0),),
                  musicSelect("Clips", Icons.video_library, getVideo),
                ],
              ) : musicSelect(isAudio? "Audio" : "Clips", Icons.check, () {}),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: titleController,
                style: TextStyle(fontSize: 20.0),
                decoration: inputDecoration("titre"),
              ),
            ),
            InkWell(
              onTap: getImage,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.white),
                width: MediaQuery.of(context).size.width*0.9,
                height: MediaQuery.of(context).size.height*0.5,
                child: image == null? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 50.0, color: Colors.black,),
                      Text("Ajouter une photo de couverture"),
                    ],
                  ),
                ): Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), image: DecorationImage(image: FileImage(image), fit: BoxFit.cover)))
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell musicSelect(String musicType, IconData icon, Function function) {
    return InkWell(
      onTap: function,
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40.0,),
                Text(musicType, style: TextStyle(fontSize: 23.0, color: Colors.black),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0), borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
        contentPadding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0)
    );
  }

  Future<Null> alertDialog(){
    return showDialog(
      barrierDismissible: true,
        context: context,
      builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text("Eléments manquants", textAlign: TextAlign.center,),
            content: Text("Le fichier audio/vidéo et le titre sont obligatoires"),
            actions: [
              FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text("Ok"))
            ],
          );
      }
    );
  }

  Future getAudio() async {
      String filePath;
      filePath = await FilePicker.getFilePath(type: FileType.audio);
      setState(() {
        isAudio = true;
        music = File(filePath);
      });
  }

  Future getVideo() async {
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);
      setState(() {
        isAudio = false;
        music = File(pickedFile.path);
      });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      image = File(pickedFile.path);
    });
  }
}



