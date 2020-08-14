import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/post.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/tiles/profile_page/profile_app_bar.dart';
import 'package:streamin/views/pages/create_new_album.dart';
import 'package:streamin/views/pages/play_music_page.dart';

class ProfilePage extends StatefulWidget {

  final User me;

  ProfilePage({Key key,@required this.me}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<Post> posts = [];
  StreamSubscription sub;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setUpSub();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ProfileAppBar(me: widget.me, other: widget.me,),
        SliverList(
            delegate: SliverChildListDelegate(
                [
                  Container(
                    child: DefaultTabController(
                      length: 2,
                      child: TabBar(
                        onTap: (int i){
                          setState(() {
                            currentIndex = i;
                          });
                        },
                        indicatorColor: Colors.black,
                        labelColor:  Colors.black,
                        unselectedLabelColor:  Colors.white,
                        tabs: [
                          Tab(icon: Icon(Icons.queue_music)),
                          Tab(icon: Icon(Icons.ondemand_video)),
                        ],
                      ),
                    ),
                    color: Color(0xFF00B97E),
                  ),
                  SizedBox(height: 10.0,)
                ]
            )
        ),
        currentIndex == 0? SliverList(
            delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                    child: Text("Albums", style: TextStyle(fontFamily: "Ariale", fontSize: 23.0)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 7.0),
                    height: 100.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateNewAlbumPage())),
                          child: Container(
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
                          width: 150.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 150.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 150.0,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue,),
                          width: 150.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                    child: Text("Les plus écoutés", style: TextStyle(fontFamily: "Ariale", fontSize: 23.0)),
                  ),
                ]
            )
        ) : posts.length == 0? SliverList(
            delegate: SliverChildListDelegate([Center(child: Text("Compte sans contenu", style: TextStyle(fontFamily: "Ariale", fontSize: 19.0),))])
        ) : SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayMusicPage(post: posts[index], user: widget.me,))),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey[300], image: DecorationImage(image: posts[index].coverImage != null? NetworkImage(posts[index].coverImage) : AssetImage("assets/logoApp.png"), fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(child: Icon(Icons.play_circle_filled, color: Colors.white, size: 35.0,),),
                        SizedBox(height: MediaQuery.of(context).size.height/8-30,),
                        Container(decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))), width: MediaQuery.of(context).size.width, height: 30.0, child: Text(posts[index].title, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontFamily: "Ariale"),), alignment: Alignment.center,),
                      ],
                    ),
                  )
              );
            },
            childCount: posts.length,
          ),
        )
      ],
    );
  }

  setUpSub(){
    sub = FireServices().fireUser.document(widget.me.uid).snapshots().listen((datas){
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
}


