import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/tiles/profile_image_tile.dart';
import 'package:streamin/views/pages/profile_page.dart';
import 'package:streamin/views/pages/music_page.dart';
import 'file:///D:/AndroidStudioProjects/stream_in/lib/views/pages/newPostPage/filePage.dart';
import 'package:streamin/views/pages/profilSignUp.dart';
import 'package:streamin/views/pages/subscription.dart';

class MainController extends StatefulWidget {
  @override
  _MainControllerState createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {

  User user;
  bool textFieldTap = false;
  TextEditingController controller;

  List<User> userSearch = [];

  @override
  void initState() {
    super.initState();
    FireServices().fireUser.document(meUid).snapshots().listen((DocumentSnapshot documentSnapshot) {
      setState(() {
        user = User(documentSnapshot);
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

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Stream'in", style: TextStyle(color: Colors.white, fontSize: 50.0, fontFamily: "Ariale"),),
              SizedBox(height: 70.0,),
              CircularProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(primaryColor),),
            ],
          ),
        ),
      );
    }
    if (user.pseudo == "" && user.musicGenre.length == 0) {
      return PersonalisationPage();
    }
    return mainController();
  }

  Scaffold mainController() {
    List<Widget> children = [
      ProfilePage(me: user),
      SubscriptionView(sliverAppBar: mainAppBar(), textFieldTap: textFieldTap, me: user, userSearch: userSearch,),
      MusicPage(sliverAppBar: mainAppBar(), textFieldTap: textFieldTap, me: user, userSearch: userSearch,),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: !textFieldTap ? BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: Icon(Icons.person,
                color: _currentIndex == 0 ? Colors.black : Colors.grey[700],
                size: 27.0,), onPressed: () => onTabTapped(0)),
              IconButton(icon: Icon(Icons.home,
                color: _currentIndex == 1 ? Colors.black : Colors.grey[700],
                size: 27.0,), onPressed: () => onTabTapped(1)),
              IconButton(icon: Icon(Icons.music_note,
                color: _currentIndex == 2 ? Colors.black : Colors.grey[700],
                size: 27.0,), onPressed: () => onTabTapped(2)),
            ],
          ),
        ) : SizedBox(height: 0.0,),
        body: children[_currentIndex],
        floatingActionButton: _currentIndex == 0 || _currentIndex == 1
            ? FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FilePage())),
          backgroundColor: primaryColor,
          child: Icon(Icons.add),
        )
            : null
    );
  }

  Widget mainAppBar(){
    return SliverAppBar(
        backgroundColor: primaryColor,
        floating: false,
        pinned: true,
        snap: false,
        expandedHeight: _currentIndex != 0? 140.0 : 0.0,
        leading: _currentIndex != 0?Padding(
          padding: EdgeInsets.all(7.5),
          child: ProfileImageTile(imageUrl: user.imageUrl, pseudo: user.pseudo) ,
        ): SizedBox.shrink(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15.0))),
        title: Text(_currentIndex == 0? user.pseudo : "Stream'In", style: TextStyle(fontFamily: "Ariale"),),
        flexibleSpace: (_currentIndex != 0)? FlexibleSpaceBar(
          background: Container(
            padding: EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top + 60.0),
            child: Padding(
              padding: textFieldTap ? EdgeInsets.all(10.0) : EdgeInsets
                  .symmetric(horizontal: 30.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textFieldTap ? IconButton(icon: Icon(
                    Icons.arrow_back, color: Colors.white,),
                      onPressed: () {
                        setState(() {
                          userSearch = [];
                          controller.text = "";
                          FocusScope.of(context).requestFocus(FocusNode());
                          textFieldTap = false;
                        });
                      }) : SizedBox.shrink(),
                  Flexible(
                    child: TextFormField(
                      onChanged: (val) {
                        searchByName(val.toLowerCase());
                      },
                      onTap: () {
                        setState(() {
                          textFieldTap = true;
                        });
                      },
                      controller: controller,
                      style: TextStyle(fontSize: 16.0),
                      decoration: inputDecoration(
                          "Chercher une musique, artiste ou ami(e) "),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) : SizedBox(height: 0.0,),
    );
  }

  searchByName(String searchField) {
    if (searchField.length == 0) {
      setState(() {
        userSearch = [];
      });
    }
    List<User> userTest = [];
    Firestore.instance.collection("users").snapshots().listen((data) {
      userTest = [];
      data.documents.forEach((element) {
        if (element["pseudo"].toString().toLowerCase().startsWith(
            searchField.substring(0, 1) + searchField.substring(1))) {
          if(element.documentID != meUid){
            setState(() {
              userTest.add(User(element));
              userSearch = userTest;
            });
          }
        }
      });
    });
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
        contentPadding: EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0)
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}