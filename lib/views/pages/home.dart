import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.red,),
                      width: 185.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.red,),
                      width: 185.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.red,),
                      width: 185.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.red,),
                      width: 185.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.red,),
                      width: 185.0,
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }
}

