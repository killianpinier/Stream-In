import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:streamin/views/login/connexion_view.dart';

class FirstView extends StatefulWidget {
  @override
  _FirstViewState createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {

  int selectedIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    List<Widget> cardPresentation = [
      presentationCard("Écoutez gratuitement toutes les musiques de vos amis ou de vos artistes préférés"),
      presentationCard("Redécouvrez le monde de la musique et devenez le meilleur dans votre domaine"),
      presentationCard("Partagez et faites vous découvrir au sein de la communauté de Stream'In et devenez le maitre de la musique")
    ];

    return Scaffold(
      backgroundColor: Color(0xFF00B97E),
      body: Container(
        width: _width,
        height: _height,
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("STREAM'IN", style: TextStyle(fontSize: 50.0, color: Colors.white, fontFamily: "Ariale"),),
                  Container(
                      height: _height*0.4,
                      child: PageView(
                        children: cardPresentation,
                        controller: _pageController,
                        onPageChanged: (int i) {
                          setState(() {
                            selectedIndex = i;
                          });
                        },
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      navigationCircle(0),
                      SizedBox(width: 15.0,),
                      navigationCircle(1),
                      SizedBox(width: 15.0,),
                      navigationCircle(2),
                    ],
                  ),
                  RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      color: Colors.white,
                      child: Text("Créer un compte", style: TextStyle(fontSize: 26.0, fontFamily: "Ariale"),),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnexionView(authFormType: AuthFormType.signUp,))),
                  ),
                  FlatButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnexionView(authFormType: AuthFormType.signIn))),
                      child: Text("Se connecter", style: TextStyle(fontSize: 28.0, fontFamily: "Ariale"),)
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget navigationCircle(int index) {
    return Container(
        width: 19.0,
        height: 19.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.5),
            color: index == selectedIndex? Colors.white : Colors.black),
    );
  }

  Widget presentationCard(String text) {
    return Container(
      color: Color(0xFF00B97E),
              margin: EdgeInsets.all(10.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(text, style: TextStyle(fontSize: 27.0, fontFamily: "Ariale"), textAlign: TextAlign.center,),
                ),
              ),
    );
  }
}
