import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/post.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/tiles/profile_page/profile_app_bar.dart';

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
                          Tab(icon: Icon(Icons.ondemand_video)),
                          Tab(icon: Icon(Icons.queue_music)),
                        ],
                      ),
                    ),
                    color: Color(0xFF00B97E),
                  ),
                ]
            )
        ),
        posts.length == 0? SliverList(
            delegate: SliverChildListDelegate([SizedBox(height: 10.0,), Center(child: Text("Compte sans contenu", style: TextStyle(fontFamily: "Ariale", fontSize: 19.0),))])
        ) : currentIndex == 0? SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return InkWell(
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey[300], image: DecorationImage(image: posts[index].coverImage != null? NetworkImage(posts[index].coverImage) : AssetImage("assets/logoApp.png"), fit: BoxFit.cover)),
                    alignment: Alignment.center,
                    child: Center(child: Icon(Icons.play_circle_filled, color: Colors.white, size: 35.0,),)
                ),
              );
            },
            childCount: posts.length,
          ),
        ) : SliverList(delegate: SliverChildListDelegate([]),)
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


