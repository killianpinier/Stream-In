import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/views/pages/musicGenrePage.dart';

class PersonalisationPage extends StatefulWidget {
  @override
  _PersonalisationPageState createState() => _PersonalisationPageState();
}

class _PersonalisationPageState extends State<PersonalisationPage> {

  TextEditingController _pseudo;
  final picker = ImagePicker();
  File imageTaken;

  @override
  void initState() {
    super.initState();
    _pseudo = TextEditingController();
  }

  @override
  void dispose() {
    _pseudo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00B97E),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20.0,),
                Text("STREAM'IN", style: TextStyle(fontSize: 50.0, color: Colors.white, fontFamily: "Ariale"),),
                SizedBox(height: 30.0,),
                Text("Veuilliez rentrer les informations suivantes afin que nous puissions créer votre compte", style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: "Ariale"), textAlign: TextAlign.center,),
                SizedBox(height: 30.0,),
                TextFormField(
                  controller: _pseudo,
                  style: TextStyle(fontSize: 22.0),
                  decoration: inputDecoration("Pseudo"),
                ),
                SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:InkWell(
                    onTap: () => mainBottomSheet(context),
                    child: Column(
                      children: [
                        imageTaken == null?
                          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(60.0), color: Colors.white), height: 120.0, width: 120.0, child: Icon(Icons.person, size: 100.0,),) :
                            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(60.0), color: Colors.white, image: DecorationImage(image: FileImage(imageTaken), fit: BoxFit.cover)), height: 120.0, width: 120.0,),
                        SizedBox(height: 10.0,),
                        Text("Changer la photo de profile", style: TextStyle(color: Colors.grey[900], fontSize: 18.0),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 14.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    Map<String, dynamic> data= {};
                    if(_pseudo.text !=null && _pseudo.text != ""){
                      data["pseudo"] = _pseudo.text;
                      FireServices().modifyUser(data);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MusicGenrePage()));
                    }else{
                      pseudoAlert();
                    }
                  },
                  child: Text("Continuer", style: TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: "Ariale"),),
                ),
                SizedBox(height: 20.0,),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
        contentPadding: EdgeInsets.only(left: 14.0, top: 16.0, bottom: 16.0)
    );
  }

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        context: context,
        builder: (BuildContext context){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    item("assets/camera.png", "Camera", () => getImage(ImageSource.camera)),
                    item("assets/gallery.png", "Gallery", () => getImage(ImageSource.gallery))
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  Future<Null> pseudoAlert() async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text("Le pseudo est obligatoire"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok")
              )
            ],
          );
        }
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 30);
    setState(() {
      imageTaken = File(pickedFile.path);
    });
    FireServices().modifyPicture(imageTaken);
  }

  InkWell item(String image, String itemType, Function function){
    return InkWell(
      onTap: function,
      child: Column(
        children: [
          Container(
              height: 40.0,
              width: 40.0,
              child: Image.asset(image)
          ),
          Text(itemType, style: TextStyle(fontSize: 16.0, color: Colors.black),)
        ],
      ),
    );
  }
}

