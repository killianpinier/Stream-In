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
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                    child: Text("Pour vous", style: TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: "Ariale"),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    height: 125.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 185.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 185.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 185.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 185.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 185.0,
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
