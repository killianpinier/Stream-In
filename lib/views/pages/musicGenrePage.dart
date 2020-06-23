import 'package:flutter/material.dart';
import 'package:streamin/services/auth_services.dart';

import '../../main.dart';

class MusicGenrePage extends StatefulWidget {
  @override
  _MusicGenrePageState createState() => _MusicGenrePageState();
}

class _MusicGenrePageState extends State<MusicGenrePage> {

  int musicGenreSelected = 0;

  List<String> musicSelected = [];
  List<ItemChildren> item = [
    ItemChildren("assets/rap.jpg", "rap"),
    ItemChildren("assets/electro.jpg", "electro"),
    ItemChildren("assets/pop.jpg", "pop"),
    ItemChildren("assets/rock.jpg", "rock"),
    ItemChildren("assets/reggea.jpg", "reggea"),
    ItemChildren("assets/techno.jpg", "techno"),
    ItemChildren("assets/folk.jpg", "folk"),
    ItemChildren("assets/jazz.jpg", "jazz"),
  ];

  List<bool> initBool = [
    false, false, false, false, false, false, false, false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00B97E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20.0,),
                RichText(
                  text: TextSpan(
                    text: 'Veuilliez sélectioner 3 genres \nmusicaux :',
                    style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: "Ariale"),
                    children: <TextSpan>[
                      TextSpan(text: " $musicGenreSelected / 3", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: "Ariale"))
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0,),
                Expanded(
                  child: GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: itemChildren(context, item[index].assetName, item[index].musicGenre, initBool[index]),
                          onTap: () {
                            if(initBool[index]){
                              setState(() {
                                musicSelected.remove(item[index].musicGenre);
                                musicGenreSelected--;
                                initBool[index] = false;
                                print(musicSelected);
                              });
                            }else{
                              if(musicSelected.length >= 3){
                                setState(() {});
                              }else{
                                setState(() {
                                  musicSelected.add(item[index].musicGenre);
                                  musicGenreSelected++;
                                  initBool[index] = true;
                                  print(musicSelected);
                                });
                              }
                            }
                          },
                        );
                      }
                  ),
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 14.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    Map<String, dynamic> data= {};
                    if(musicSelected.length == 3) {
                      data["musicGenre"] = musicSelected;
                      AuthService().modifyUser(data);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeController()));
                    }
                  },
                  child: Text("Continuer", style: TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: "Ariale"),),
                ),
                SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemChildren(BuildContext context, String assetName, String musicGenre, bool selected){
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), image: DecorationImage(image: AssetImage(assetName), fit: BoxFit.cover, colorFilter: selected? ColorFilter.mode(Colors.grey.withOpacity(0.4), BlendMode.dstATop) : null)),
          width: MediaQuery.of(context).size.width/2.5,
          height: MediaQuery.of(context).size.width/2.5,
          child: Center(
            child: selected? Icon(Icons.check, size: 55.0, color: Colors.white,) : Text(musicGenre, style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        )
    );
  }

}

class ItemChildren{
  final String assetName;
  final String musicGenre;

  ItemChildren(this.assetName, this.musicGenre);
}