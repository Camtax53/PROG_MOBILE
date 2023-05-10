import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

List<Offset> obstacle = [];

class LabyrinthePage extends StatefulWidget {
  const LabyrinthePage({Key? key});

  @override
  _LabyrintheState createState() => _LabyrintheState();
}

class _LabyrintheState extends State<LabyrinthePage> {
  double _ballPositionX = 0.0;
  double _ballPositionY = 0.0;

  double sizeBall = 30.0;
  double speed = 15;
  bool isVisible = true;

  double screenWidth = 0.0;
  double screenHeight = 0.0;
  double appBarHeight = 0.0;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  //late Offset succes;

  @override
  Widget build(BuildContext context) {
    if (_ballPositionX == 0.0 || _ballPositionY == 0.0) {
      _ballPositionX = 40;
      _ballPositionY = screenHeight / 4;
    }

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Labyrinthe"),
      ),
      body: Stack(children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          left: _ballPositionX,
          bottom: _ballPositionY,
          child: Container(
            width: 50,
            height: 50,
            child: Icon(
              Icons.sports_volleyball,
              color: Colors.red,
              size: sizeBall,
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          updateBallPosition(event);
        });
      }
    });
  }

  void updateBallPosition(AccelerometerEvent event) {
    double y = event.x;
    double x = event.y;
    print("x : $x");
    print("y : $y");

    if (x > 2.5) {
      //droite
      if (_ballPositionX + speed < screenWidth - sizeBall - 20) {
        _ballPositionX += speed;
      } else {
        _ballPositionX = screenWidth - sizeBall - 10;
      }
    } else if (x < -2.5) {
      //gauche
      if (_ballPositionX - speed > 0) {
        _ballPositionX -= speed;
      } else {
        _ballPositionX = 0 - sizeBall / 4;
      }
    }

    if (y > 8) {
      //bas
      if (_ballPositionY - speed > sizeBall / 4) {
        _ballPositionY -= speed;
      } else {
        _ballPositionY = 0 - sizeBall / 4;
      }
    } else if (y < 6) {
      //haut
      if (_ballPositionY + speed <
          screenHeight - appBarHeight - sizeBall - 20) {
        _ballPositionY += speed;
      } else {
        _ballPositionY = screenHeight - appBarHeight - sizeBall - 10;
      }
    }
    if (x > 2.5 && y > 8) {
      // diagonale bas droite
      _ballPositionX -= 2.5;
      _ballPositionY -= 2.5;
    } else if (x < -2.5 && y > 8) {
      // diagonale haut droite
      _ballPositionX -= 2.5;
      _ballPositionY += 2.5;
    } else if (x > 2.5 && y < 6) {
      // diagonale bas gauche
      _ballPositionX += 2.5;
      _ballPositionY -= 2.5;
    } else if (x < -2.5 && y < 6) {
      // diagonale haut gauche
      _ballPositionX += 2.5;
      _ballPositionY += 2.5;
    }

    // _ballPositionX = _ballPositionX.clamp(0, screenWidth - 50);
    // _ballPositionY = _ballPositionY.clamp(0, screenHeight - 50);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
