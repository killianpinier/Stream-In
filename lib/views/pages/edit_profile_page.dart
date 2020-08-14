import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';

class EditProfilePage extends StatefulWidget {

  final User user;

  EditProfilePage({@required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  Color primaryColor = Color(0xFF00B97E);

  TextEditingController pseudo;
  TextEditingController desc;
  TextEditingController email;
  TextEditingController phone;

  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    pseudo = TextEditingController(text: widget.user.pseudo);
    desc = TextEditingController(text: widget.user.description);
    email = TextEditingController(text: widget.user.email);
    phone = TextEditingController(text: widget.user.phone.toString());
  }

  @override
  void dispose() {
    pseudo.dispose();
    desc.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Modifier le profil", style: TextStyle(fontFamily: "Ariale", color: Colors.white),),
        actions: [
          IconButton(icon: Icon(Icons.check, color: Colors.black,), onPressed: (){})
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10.0,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.user.imageUrl == "" || widget.user.imageUrl == null? Container (
                    height: 100.0, width: 100.0,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0),border: Border.all(width: 1.0, color: Colors.grey[400]), color: Colors.grey[100]),
                    child: Center(child: Text(widget.user.pseudo[0].toUpperCase(), style: TextStyle(color: Colors.black, fontFamily: "Ariale", fontSize: 23.0))),
                  ) : Container(height: 100.0, width: 100.0,
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.user.imageUrl), fit: BoxFit.cover), color: Colors.grey[400], borderRadius: BorderRadius.circular(50.0)),
                  ),
                  SizedBox(height: 5.0,),
                  Text("Modifier la photo de profil", style: TextStyle(fontFamily: "Ariale", fontSize: 16.0),)
                ],
              ),
              textField(1, "Pseudo", pseudo, TextInputType.text),
              textField(5, "Description", desc, TextInputType.text),
              Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                margin: EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Informations de contact", style: TextStyle(fontFamily: "Ariale", fontSize: 17.0),),
                          Switch(
                              value: switchValue,
                              onChanged: (bool b){
                                setState(() {
                                  switchValue = b;
                                  print(switchValue);
                                });
                              }
                          )
                        ],
                      ),
                      Text("Choisissez de montrer ou pas vos informations de contact", style: TextStyle(fontFamily: "Ariale", color: Colors.grey),),
                      Text("widget.user.email", style: TextStyle(color: Colors.grey, fontFamily: "Ariale"),),
                      textField(1, "Téléphone", phone, TextInputType.phone),
                    ],
                  ),
                ),
              ),
              FlatButton(onPressed: (){setState(() {FireServices().logOut();});}, child: Text("Se déconecter", style: TextStyle(color: Colors.red, fontFamily: "Ariale", fontSize: 18.0),))
            ],
          ),
        ),
      ),
    );
  }

//  getEmail(){
//    FirebaseUser user = FirebaseUser()
//  }

  Padding textField(int maxLines, String label, TextEditingController controller, TextInputType type){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: TextField(
        keyboardType: type,
          minLines: 1,
          maxLines: maxLines,
          controller: controller,
          style: TextStyle(fontSize: 17.0, fontFamily: "Ariale"),
          decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: Colors.grey[400], fontFamily: "Ariale"))
      ),
    );
  }
}
