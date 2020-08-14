import 'package:flutter/material.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/tiles/user_search_tile.dart';

class MusicPage extends StatelessWidget {
  final User me;
  final SliverAppBar sliverAppBar;
  final bool textFieldTap;
  final List<User> userSearch;

  MusicPage({Key key,@required this.sliverAppBar, @required this.textFieldTap, @required this.me, @required this.userSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFF00B97E);
    return textFieldTap? CustomScrollView(
      slivers: [
        sliverAppBar,
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return UserSearchTile(me: me, other: userSearch[index]);
            },
            childCount: userSearch.length,
          ),
        )
      ],
    ) : CustomScrollView(
      slivers: [
        sliverAppBar,
        SliverList(
            delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: (){},
                        color: Colors.white,
                        child: Text("Mes téléchargements", style: TextStyle(fontFamily: "Ariale"),),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        elevation: 10.0,
                      ),
                      RaisedButton(
                        onPressed: (){},
                        color: Colors.white,
                        child: Text("Morceaux préférés", style: TextStyle(fontFamily: "Ariale"),),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        elevation: 10.0,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                    child: Text("Playlists", style: TextStyle(fontFamily: "Ariale", fontSize: 23.0)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 7.0),
                    height: 100.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            elevation: 10.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, size: 35.0),
                                Text("Créer", style: TextStyle(fontFamily: "Ariale"),)
                              ],
                            ),
                          ),
                          width: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 100.0,
                        ),
                      ],
                    ),
                  ),

                ]
            )
        )
      ],
    );
  }
}
