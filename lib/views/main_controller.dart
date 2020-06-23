import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/auth_services.dart';
import 'package:streamin/views/pages/home.dart';
import 'package:streamin/views/pages/music.dart';
import 'package:streamin/views/pages/profilSignUp.dart';
import 'package:streamin/views/pages/subscription.dart';

class MainController extends StatefulWidget {
  @override
  _MainControllerState createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {

  User user;
  String url;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    AuthService().fireUser.document(meUid).snapshots().listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data;
      setState(() {
        user = User(data);
      });
    });
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int _currentIndex = 1;
  Color primaryColor = Color(0xFF00B97E);

  final List<Widget> _children = [
    SubscriptionView(),
    HomeView(),
    MusicPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if(user == null){
      return Center(child: CircularProgressIndicator(),);
    }
    if(user.pseudo == "" && user.musicGenre.length == 0){
      return PersonalisationPage();
    }
    return mainController();
  }

  Scaffold mainController(){
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.group, color: _currentIndex==0?Colors.black:Colors.grey[700], size: 27.0,), onPressed: () => onTabTapped(0)),
            IconButton(icon: Icon(Icons.home, color: _currentIndex==1?Colors.black:Colors.grey[700], size: 27.0,), onPressed: () => onTabTapped(1)),
            IconButton(icon: Icon(Icons.music_note, color: _currentIndex==2?Colors.black:Colors.grey[700], size: 27.0,),  onPressed: () => onTabTapped(2)),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              backgroundColor: primaryColor,
              floating: false,
              pinned: true,
              snap: false,
              expandedHeight: 140.0,
              leading: Padding(
                padding: EdgeInsets.all(7.5),
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),border: Border.all(color: Colors.white, width: 0.5), image: DecorationImage(image: NetworkImage(user.imageUrl), fit: BoxFit.cover), color: Colors.white,),
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0))),
              title: Text("Stream'In", style: TextStyle(fontFamily: "Ariale"),),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: controller,
                      style: TextStyle(fontSize: 16.0),
                      decoration: inputDecoration("Chercher une musique, artiste ou ami(e) "),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => AuthService().logOut(),
                ),
              ]
          ),
          _children[_currentIndex]
        ],
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1? FloatingActionButton(
          onPressed: () {},
        backgroundColor: primaryColor,
          child: Icon(Icons.add),
      ) : null
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0), borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
        contentPadding: EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0)
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
