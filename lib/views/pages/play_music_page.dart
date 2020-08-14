import 'package:flutter/material.dart';
import 'package:streamin/model/post.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/tiles/clip_tile.dart';

class PlayMusicPage extends StatelessWidget {

  final Post post;
  final User user;

  PlayMusicPage({this.post, this.user});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFF00B97E);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Stream'in", style: TextStyle(fontFamily: "Ariale", fontSize: 25.0),),
        centerTitle: true,
      ),
      body: Center(child: ClipTile(post: post, user: user)),
    );
  }
}
