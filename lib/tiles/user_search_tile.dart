import 'package:flutter/material.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/views/pages/profile_search_page.dart';

class UserSearchTile extends StatelessWidget {

  final User me;
  final User other;

  UserSearchTile({Key key, @required this.me, @required this.other}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    Color primaryColor = Color(0xFF00B97E);

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileSearchPage(me: me,other: other))),
      child: Container(
        margin: EdgeInsets.only(left: 10.0),
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                other.imageUrl == "" || other.imageUrl == null?
                Container (
                  height: 60.0, width: 60.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: primaryColor),
                  child: Center(child: Text(other.pseudo[0].toUpperCase(), style: TextStyle(color: Colors.black, fontFamily: "Ariale"))),
                ) : Container(height: 60.0, width: 60.0,
                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(other.imageUrl), fit: BoxFit.cover), color: Colors.grey[400], borderRadius: BorderRadius.circular(30.0)),
                ) ,
                SizedBox(width: 10.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(other.pseudo, style: TextStyle(fontFamily: "Ariale", fontSize: 17.0),),
                    Text("${other.followers.length-1} abonnés", style: TextStyle(fontFamily: "Ariale", fontSize: 13.0),)
                  ],
                )
              ],
            ),
            FlatButton(
                onPressed: () => FireServices().addFollow(me.following, me, other),
                child: Text(me.following.contains(other.uid)? "Se désabonner" : "S'abonner", style: TextStyle(fontFamily: "Ariale", color: primaryColor),)
            )
          ],
        ),
      ),
    );
  }
}
