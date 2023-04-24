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
  double speed = 20.0;
  bool isVisible = true;

  double screenWidth = 0.0;
  double screenHeight = 0.0;
  double appBarHeight = 0.0;

  late Offset succes;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    if (_ballPositionX == 0.0 || _ballPositionY == 0.0) {
      _ballPositionX = 40;
      _ballPositionY = screenHeight / 4;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Labyrinthe"),
      ),
      body: Stack(
        children: [
          for (var point in obstacle)
            Positioned(
              left: point.dx,
              bottom: point.dy,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.blue,
              ),
            ),
          Positioned(
            bottom: succes.dy,
            left: succes.dx,
            child:
                const Icon(Icons.circle_sharp, color: Colors.green, size: 50),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _ballPositionX,
            bottom: _ballPositionY,
            child: isVisible
                ? Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.sports_volleyball,
                      color: Colors.red,
                      size: sizeBall,
                    ),
                  )
                : Container(), // Cacher la balle
          ),
        ],
      ),
    );
  }

  double x_init = 0.0;
  double y_init = 0.0;
  int count = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initialize screenWidth, screenHeight and appBarHeight after the first frame is built
      setState(() {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;
        appBarHeight =
            AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
      });
    });

    final random = Random();
    for (int i = 0; i < 5; i++) {
      final offset = Offset(
        random.nextDouble() * screenWidth,
        random.nextDouble() * (screenHeight - appBarHeight - 50) + appBarHeight,
      );
      obstacle.add(offset);
    }
    succes = Offset(MediaQuery.of(context).size.width - 90,
        screenHeight / 2 - appBarHeight / 2);

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (count < 1) {
        x_init = event.x;
        y_init = event.y;
        count++;
      }
      setState(() {
        updateBallPosition(event);
      });
    });
  }

  void updateBallPosition(AccelerometerEvent event) {
    double y = event.x;
    double x = event.y;
    double sensibility = 0.8;
    print('x: $x, xinit: $x_init, y: $y, yinit: $y_init');
    if (x > sensibility) {
      //droite
      if (_ballPositionX + speed < screenWidth - sizeBall - 20) {
        _ballPositionX += speed;
      } else {
        _ballPositionX = screenWidth - sizeBall - 10;
      }
    } else if (x < -sensibility) {
      //gauche
      if (_ballPositionX - speed > 0) {
        _ballPositionX -= speed;
      } else {
        _ballPositionX = 0 - sizeBall / 4;
      }
    }

    if (y > x_init + sensibility) {
      //bas
      if (_ballPositionY - speed > sizeBall / 4) {
        _ballPositionY -= speed;
      } else {
        _ballPositionY = 0 - sizeBall / 4;
      }
    } else if (y < x_init - sensibility) {
      //haut
      if (_ballPositionY + speed <
          screenHeight - appBarHeight - sizeBall - 20) {
        _ballPositionY += speed;
      } else {
        _ballPositionY = screenHeight - appBarHeight - sizeBall - 10;
      }
    }

    if ((succes.dx - _ballPositionX).abs().round() <= sizeBall / 2 &&
        (succes.dy - _ballPositionY).abs().round() <= sizeBall / 2) {
      isVisible = false;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
