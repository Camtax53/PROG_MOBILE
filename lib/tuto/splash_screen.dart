import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../Auth/widget_Tree.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // video controller
  late VideoPlayerController _controller;

  @override
  void initState(){
    super.initState();
     _controller = VideoPlayerController.asset(
      'assets/video/chargementVideo.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
    })
    ..setVolume(0.0);
    _playVideo();
  }

void _playVideo() async{
  _controller.play();
  await Future.delayed(const Duration(seconds: 7));
 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  const WidgetTree()),
                  );
}

@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: _controller.value.isInitialized
        ? AspectRatio(aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(
          _controller,
         ),
         )
         :Container(),
        ),
    );
  }
}