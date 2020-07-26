import 'package:flutter/material.dart';

class ProfileImageTile extends StatelessWidget {

  final String imageUrl;
  final String pseudo;

  ProfileImageTile({Key key, @required this.imageUrl, @required this.pseudo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      if(imageUrl == "" || imageUrl == null){
        return CircleAvatar(child: Text(pseudo[0].toUpperCase(), style: TextStyle(color: Colors.black, fontFamily: "Ariale")), backgroundColor: Colors.white,);
      }else{
        return CircleAvatar(backgroundImage: NetworkImage(imageUrl), backgroundColor: Colors.white,);
      }
  }
}
