import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/post.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/tiles/clip_tile.dart';
import 'package:streamin/tiles/user_search_tile.dart';

class SubscriptionView extends StatefulWidget {

  final User me;
  final SliverAppBar sliverAppBar;
  final bool textFieldTap;
  final List<User> userSearch;

  SubscriptionView({Key key,@required this.sliverAppBar, @required this.textFieldTap, @required this.me, @required this.userSearch}) : super(key: key);

  @override
  _SubscriptionViewState createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {

  StreamSubscription sub;
  List<Post> posts = [];
  List<User> users = [];

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

  Widget build(BuildContext context) {
    return widget.textFieldTap? CustomScrollView(
      slivers: [
        widget.sliverAppBar,
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return UserSearchTile(me: widget.me, other: widget.userSearch[index]);
            },
            childCount: widget.userSearch.length,
          ),
        )
      ],
    ) : CustomScrollView(
      slivers: [
        widget.sliverAppBar,
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index){
              Post post = posts[index];
              User user = users.singleWhere((u) => u.uid == post.uid);
              return Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  margin: EdgeInsets.all(10.0),
                  child: ClipTile(post: post, user: user,)
              );
            },
            childCount: posts.length,
          ),
        ),
      ],
    );
  }



  setUpSub(){
    sub = FireServices().fireUser.where("followers", arrayContains: meUid).snapshots().listen((datas){
      getUsers(datas.documents);
      datas.documents.forEach((docs) {
        docs.reference.collection("posts").snapshots().listen((post) {
          setState(() {
            posts = getPosts(post.documents);
          });
        });
      });
    });
  }

  getUsers(List<DocumentSnapshot> userDocs) {
    List<User> myList = users;
    userDocs.forEach((u) {
      User user = User(u);
      if(myList.every((p) => p.uid != user.uid)) {
        myList.add(user);
      }else{
        User toBeChanged = myList.singleWhere((p) => p.uid == user.uid);
        myList.remove(toBeChanged);
        myList.add(user);
      }
    });
    setState(() {
      users = myList;
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
