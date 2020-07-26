import 'package:flutter/material.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/views/main_controller.dart';
import 'package:streamin/views/login/first_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeController(),
      routes: <String, WidgetBuilder>{
        "/home" : (BuildContext context) => HomeController(),
      },
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FireServices().onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if(snapshot.connectionState == ConnectionState.active) {
            meUid = snapshot.data;
            final bool signedIn = snapshot.hasData;
            return signedIn ? MainController() : FirstView();
          }
          return CircularProgressIndicator();
        }
    );
  }
}


