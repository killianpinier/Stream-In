import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streamin/model/user.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/views/pages/edit_profile_page.dart';


class ProfileAppBar extends StatefulWidget {
  final User me;
  final User other;

  ProfileAppBar({this.me, @required this.other});

  @override
  _ProfileAppBarState createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {

  int selectedIndex = 0;
  PageController _pageController;
  List<dynamic> following = [];

  @override
  void initState() {
    super.initState();
    Firestore.instance.collection("users").document(meUid).snapshots().listen((DocumentSnapshot documentSnapshot) {
      setState(() {
        following = documentSnapshot["following"];
      });
      print(following);
    });
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardPresentation = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.other.imageUrl == "" || widget.other.imageUrl == null?
            Container (
              height: 75.0, width: 75.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(37.5), color: Colors.white),
              child: Center(child: Text(widget.other.pseudo[0].toUpperCase(), style: TextStyle(color: Colors.black, fontFamily: "Ariale", fontSize: 23.0))),
            ) : Container(height: 75.0, width: 75.0,
              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.other.imageUrl), fit: BoxFit.cover), color: Colors.grey[400], borderRadius: BorderRadius.circular(37.5)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${widget.other.musicGenre[0]} - ${widget.other.musicGenre[1]} - ${widget.other.musicGenre[2]}", style: TextStyle(color: Colors.white, fontFamily: "Ariale", fontSize: 18.0),),
                    Text("${widget.other.followers.length} abonnés", style: TextStyle(color: Colors.black, fontFamily: "Ariale", fontSize: 18.0),),
                    Text("${widget.other.totalViews} vues", style: TextStyle(color: Colors.black, fontFamily: "Ariale", fontSize: 18.0),),
                  ],
                ),
            ),
          ],
        ),
      ),
      InkWell(
        onTap: (){
          if(widget.other.uid == meUid){
            showDialog(
                context: context,
              barrierDismissible: false,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  title: Text("Modifier la description", style: TextStyle(fontFamily: "Ariale"),),
                  content: TextField(
                    
                  ),
                  actions: [
                    FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text("Annuler", style: TextStyle(fontFamily: "Ariale", color: Colors.red),)),
                    FlatButton(onPressed: (){}, child: Text("Continuer", style: TextStyle(fontFamily: "Ariale", color: Colors.blue),)),
                  ],
                );
              }
            );
          }
        },
        child: Card(
            elevation: 10.0,
            margin: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.other.description == ""? "Aucune Description..." : widget.other.description, style: TextStyle(fontFamily: "Ariale", fontSize: 14.0), maxLines: 3, overflow: TextOverflow.ellipsis,),
            )
        ),
      ),
    ];
    return SliverAppBar(
        backgroundColor: Color(0xFF00B97E),
        floating: false,
        pinned: true,
        snap: false,
        expandedHeight: 200.0 ,
        title: Text(widget.other.pseudo, style: TextStyle(fontFamily: "Ariale"),),
        centerTitle: false,
        actions: [
          widget.other.uid == meUid? InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfilePage(user: widget.other,))),
            child: Card(
              elevation: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5,),
                child: Center(child: Text("Modifier le profil", style: TextStyle(fontFamily: "Ariale", color: Colors.black),))
              ),
            ),
          ) : InkWell(
            onTap: () => FireServices().addFollow(following, widget.me, widget.other),
            child: Card(
              elevation: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5),
                child: Row(children: [following.contains(widget.other.uid)? SizedBox.shrink() : Icon(Icons.add, color: Colors.black, size: 20.0,), Text(following.contains(widget.other.uid)? " Se désabonner" : " S'abonner", style: TextStyle(fontFamily: "Ariale", color: Colors.black),),]),
              ),
            ),
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60.0),
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: PageView(
                              children: cardPresentation,
                              controller: _pageController,
                              onPageChanged: (int i) {
                                setState(() {
                                  selectedIndex = i;
                                });
                              },
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 100.0,
                            //width: 300.0,
                          ),
                          Row(
                              children: [
                                navigationCircle(0),
                                SizedBox(width: 10.0,),
                                navigationCircle(1),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ),
        )
    );
  }

  Widget navigationCircle(int index) {
    return Container(
      width: 9.0,
      height: 9.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.5),
          color: index == selectedIndex? Colors.white : Colors.black),
    );
  }
}
