import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:streamin/main.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:streamin/views/pages/profilSignUp.dart';

enum AuthFormType {signIn, signUp, reset}

class ConnexionView extends StatefulWidget {
  final AuthFormType authFormType;

  ConnexionView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _ConnexionViewState createState() => _ConnexionViewState(authFormType: this.authFormType);
}

class _ConnexionViewState extends State<ConnexionView> {

  TextEditingController _mail;
  TextEditingController _pwd;

  @override
  void initState() {
    super.initState();
    _mail = TextEditingController();
    _pwd = TextEditingController();
  }

  @override
  void dispose() {
    _mail.dispose();
    _pwd.dispose();
    super.dispose();
  }

  AuthFormType authFormType;
  _ConnexionViewState({this.authFormType});
  
  String _error;
  Color primaryColor = Color(0xFF00B97E);
  
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          height: _height,
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    showAlert(),
                    Text("STREAM'IN", style: TextStyle(fontSize: 50.0, color: Colors.white, fontFamily: "Ariale"),),
                    Column(
                        children: buildInputs() + buildButton()
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  void submit() async {
    if(_mail.text != "" && _mail.text != null){
      if(_pwd.text != "" && _pwd.text != null){
        switch(authFormType){
          case AuthFormType.signIn:
            _onLoading("signin");
            break;
          case AuthFormType.signUp:
            _onLoading("signup");
            break;
          case AuthFormType.reset:
            await FireServices().resetPassword(_mail.text);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeController()));
            break;
        }
      }
    }
  }

  Widget showAlert() {
    if(_error != null) {
      return Container(
        height: 50.0,
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(_error, maxLines: 3,),
                )
            ),
            IconButton(icon: Icon(Icons.close), onPressed: () {setState(() {_error = null;});})
          ],
        ),
      );
    }
    return SizedBox(height: 0.0,);
  }
  
  buildInputs(){
    List<Widget> inputs = [];
    if(authFormType == AuthFormType.signIn || authFormType == AuthFormType.signUp){
      inputs.add(
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _mail,
          style: TextStyle(fontSize: 22.0),
          decoration: inputDecoration("Email"),
        ),
      );
      inputs.add(SizedBox(height: 20.0,));
      inputs.add(
        TextFormField(
          obscureText: true,
          controller: _pwd,
          style: TextStyle(fontSize: 22.0),
          decoration: inputDecoration("Mot de passe"),
        ),
      );
      return inputs;
    }else{
      inputs.add(
        TextFormField(
          controller: _mail,
          style: TextStyle(fontSize: 22.0),
          decoration: inputDecoration("Email"),
        ),
      );
      return inputs;
    }
  }

  buildButton() {
    List<Widget> buttons = [];
    buttons.add(SizedBox(height: 40.0,));
    if(authFormType == AuthFormType.signIn) {
      buttons.add(
          FlatButton(
              onPressed: (){
                setState(() {
                  authFormType = AuthFormType.reset;
                });
              },
              child: Text("Mot de passe oublié ?", style: TextStyle(color: Colors.black, fontFamily: "Ariale", fontSize: 15.0),)
          )
      );
      buttons.add(
          FlatButton(
            onPressed: () {
              setState(() {
                authFormType = AuthFormType.signUp;
              });
              },
            child: Text("Pas de compte ? Créez un compte", style: TextStyle(color: Colors.white, fontFamily: "Ariale", fontSize: 15.0),),
          )
      );
      buttons.add(SizedBox(height: 40.0,));
      buttons.add(
        RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 14.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: submit,
          child: Text("Se connecter", style: TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: "Ariale"),),
        ),
      );
      buttons.add(SizedBox(height: 35.0,));
      buttons.add(buildSocialBtnrow());
      return buttons;
    }else if(authFormType == AuthFormType.signUp){
      buttons.add(
          FlatButton(
            onPressed: () {
              setState(() {
                authFormType = AuthFormType.signIn;
              });
              },
            child: Text("Déja un compte ? Connectez vous", style: TextStyle(color: Colors.white, fontFamily: "Ariale", fontSize: 15.0),),
          )
      );
      buttons.add(SizedBox(height: 40.0,));
      buttons.add(
        RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 14.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: submit,
          child: Text("Créer un compte", style: TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: "Ariale"),),
        ),
      );
      buttons.add(SizedBox(height: 35.0,));
      buttons.add(buildSocialBtnrow());
      return buttons;
    }else{
      buttons.add(
        RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 14.0),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: submit,
          child: Text("Envoyer", style: TextStyle(color: Colors.black, fontSize: 22.0, fontFamily: "Ariale"),),
        ),
      );
      buttons.add(SizedBox(height: 20.0,));
      buttons.add(
        FlatButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text("Annuler", style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: "Ariale"),)
        )
      );
      return buttons;
    }
  }

  Widget buildSocialBtnrow() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildSocialBtn("assets/facebook.png", "facebook"),
              buildSocialBtn("assets/google.jpg", "google"),
            ],
          );
  }
  
  buildSocialBtn(String image, String signInType){
    return GestureDetector(
      onTap: () async{
        if(signInType == "google"){
          _onLoading("google");
        }else{
          _onLoading("facebook");
        }
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
  
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
      contentPadding: EdgeInsets.only(left: 14.0, top: 16.0, bottom: 16.0)
    );
  }

  void _onLoading(String connexionType) async{
    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //connected to internet
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      //not connected to internet
      setState(() {
        connected = false;
      });
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                connected? CircularProgressIndicator() : Text("Une erreur est apparu", style: TextStyle(fontSize: 17.0, fontFamily: "Ariale")),
                SizedBox(height: 10.0,),
                Text(connected? "Chargement" : "Vérifiez votre connection internet", style: TextStyle(fontSize: 15.0, fontFamily: "Ariale"),),
                SizedBox(height: 10.0,),
                connected? SizedBox(height: 0,) : FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text("Ok", style: TextStyle(color: Colors.blue),),)
              ],
            ),
          ),
        );
      },
    );
    if(connected){
      try{
        if(connexionType == "signin"){
          await FireServices().signIn(_mail.text, _pwd.text).whenComplete(() =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeController())));
        }else if(connexionType == "signup"){
          await FireServices().createAccount(_mail.text,_pwd.text).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PersonalisationPage())));
        }else if(connexionType == "google"){
          await FireServices().signInWithGoogle().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeController())));
        }else if(connexionType == "facebook"){
          await FireServices().facebookLogin().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeController())));
        }
      }catch(e) {
        setState(() {
          _error = e.message;
        });
        print(_error);
      }
    }
  }
}