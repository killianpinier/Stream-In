import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:streamin/services/fire_services.dart';
import 'package:video_player/video_player.dart';

class CustomPostPage extends StatefulWidget {

  final File music;
  final File coverImage;
  final String title;
  final bool isAudio;

  CustomPostPage({Key key, @required this.music, @required this.title,@required this.isAudio, this.coverImage}) : super(key: key);

  @override
  _CustomPostPageState createState() => _CustomPostPageState();
}

class _CustomPostPageState extends State<CustomPostPage> {

  _CustomPostPageState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  Color primaryColor = Color(0xFF00B97E);
  bool tap = false;
  TextEditingController desController;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.music);
    _initializeVideoPlayerFuture = _controller.initialize();
    desController = TextEditingController();
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.dispose();
    desController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    int position = _controller.value.position.inSeconds.toInt();
    int duration = _controller.value.duration.inSeconds.toInt();
    int time = duration - position;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Text("Nouveau post",style: TextStyle( color: Colors.white, fontFamily: "Ariale"),),
        actions: [
          InkWell(
            onTap: (){
              sendToFireBase();
              Navigator.of(context).popUntil((route) => route.isFirst);
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainController()));
    },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(child: Text("Partager", style: TextStyle(color: Colors.black, fontFamily: "Ariale"),)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                if(tap){
                  setState(() {
                    tap = !tap;
                  });
                  Timer(Duration(seconds: 4), (){
                    setState(() {
                      tap = !tap;
                    });
                  });
                }else{
                  setState(() {
                    tap = !tap;
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.black,),
                height: MediaQuery.of(context).size.height*0.6,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if(widget.isAudio){
                            return VideoPlayer(_controller);
                        }else{
                          return AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Center(child: VideoPlayer(_controller),)
                          );
                        }
                      },
                    ),
                    AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        reverseDuration: Duration(milliseconds: 500),
                        child: tap ?
                        SizedBox.shrink() : Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.black26,),
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                    child: IconButton(
                                        icon: Icon(_controller.value.isPlaying? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50,),
                                        onPressed: () {
                                          _controller.value.isPlaying? _controller.pause() : _controller.play();
                                        }
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: primaryColor,
                                          inactiveTrackColor: Colors.grey[700],
                                          trackHeight: 2.0,
                                          thumbColor: primaryColor,
                                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                          overlayColor: Colors.purple.withAlpha(32),
                                          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                                        ),
                                        child: Slider(
                                          min: 0.0,
                                          max: duration.toDouble(),
                                          value: position.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              _controller.seekTo(Duration(seconds: value.toInt()));
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(getVideoTime(time), style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                minLines: 3,
                maxLines: 5,
                controller: desController,
                style: TextStyle(fontSize: 20.0),
                decoration: inputDecoration("Description..."),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendToFireBase(){
    FireServices().addPost(widget.music, widget.title, widget.coverImage, desController.text, widget.isAudio);
  }

  String getVideoTime(int time) {
    String result;
    if(time<=59){ // 1 minutes
      if(time<10){
        result = "0:0${time.toString()}";
      }else{
        result = "0:${time.toString()}";
      }
    }else if(time>59 && time<=119){ // 2 minutes
      time = time - 60;
      if(time<10){
        result = "1:0${time.toString()}";
      }else{
        result = "1:${time.toString()}";
      }
    }else if(time>119 && time<=179){
      time = time - 120;
      if(time<10){
        result = "2:0${time.toString()}";
      }else{
        result = "2:${time.toString()}";
      }
    }else if(time>179 && time<=239){
      time = time - 180;
      if(time<10){
        result = "3:0${time.toString()}";
      }else{
        result = "3:${time.toString()}";
      }
    }else if(time>239 && time<=299){
      time = time - 240;
      if(time<10){
        result = "4:0${time.toString()}";
      }else{
        result = "4:${time.toString()}";
      }
    }else if(time>299 && time<=359){
      time = time - 300;
      if(time<10){
        result = "5:0${time.toString()}";
      }else{
        result = "5:${time.toString()}";
      }
    }
    return result;
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0), borderSide: BorderSide(width: 0, style: BorderStyle.none,),),
        contentPadding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0)
    );
  }
}

