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
  Offset _ballPosition = Offset(0.0, 0.0);
  late Offset successPosition;

  double sizeBall = 30.0;
  double speed = 20.0;
  late double speedDiag;
  bool isVisible = true;
  int counter = 0;
  bool isGameOver = false;

  double screenWidth = 0.0;
  double screenHeight = 0.0;
  double appBarHeight = 0.0;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    if (_ballPosition == Offset(0.0, 0.0)) {
      _ballPosition = Offset(MediaQuery.of(context).size.width - 350,
          screenHeight / 2 - appBarHeight / 2);
    }
    successPosition = Offset(MediaQuery.of(context).size.width - 90,
        screenHeight / 2 - appBarHeight / 2);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    if (isGameOver) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: const Text('Vous avez perdu !'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Remettre la balle à la position initiale et réinitialiser le compteur
                  setState(() {
                    _ballPosition = Offset(
                        MediaQuery.of(context).size.width - 350,
                        screenHeight / 2 - appBarHeight / 2);
                    counter = 0;
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Labyrinthe"),
        actions: [
          Text(counter.toString()),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: successPosition.dy,
            left: successPosition.dx,
            child:
                const Icon(Icons.circle_sharp, color: Colors.green, size: 50),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _ballPosition.dx,
            bottom: _ballPosition.dy,
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
          if (counter <= obstacle.length)
            ...List.generate(
              counter,
              (index) => Positioned(
                left: obstacle[index].dx,
                top: obstacle[index].dy,
                child: const Icon(Icons.circle, color: Colors.red, size: 50),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    obstacle = [
      Offset(300, 200),
      Offset(400, 50),
    ];
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
    speedDiag = speed / sqrt(2);
    double y = event.x;
    double x = event.y;
    // print("x : $x");
    // print("y : $y");

    if (!isVisible) {
      _ballPosition = Offset(40, screenHeight / 4);
      Timer(const Duration(milliseconds: 500), () {
        isVisible = true;
      });
    }

    if (x > 2.5) {
      //droite
      if (_ballPosition.dx + speed < screenWidth - sizeBall - 20) {
        _ballPosition = Offset(_ballPosition.dx + speed, _ballPosition.dy);
      } else {
        _ballPosition = Offset(screenWidth - sizeBall - 10, _ballPosition.dy);
      }
    } else if (x < -2.5) {
      //gauche
      if (_ballPosition.dx - speed > 0) {
        _ballPosition = Offset(_ballPosition.dx - speed, _ballPosition.dy);
      } else {
        _ballPosition = Offset(0 - sizeBall / 4, _ballPosition.dy);
      }
    }

    if (y > 8) {
      //bas
      if (_ballPosition.dy - speed > sizeBall / 4) {
        _ballPosition = Offset(_ballPosition.dx, _ballPosition.dy - speed);
      } else {
        _ballPosition = Offset(_ballPosition.dx, 0 - sizeBall / 4);
      }
    } else if (y < 6) {
      //haut
      if (_ballPosition.dy + speed <
          screenHeight - appBarHeight - sizeBall - 20) {
        _ballPosition = Offset(_ballPosition.dx, _ballPosition.dy + speed);
      } else {
        _ballPosition = Offset(
            _ballPosition.dx, screenHeight - appBarHeight - sizeBall - 10);
      }
    }

    // Diagonales
    if (x > 2.5 && y > 8) {
      // Droite bas
      if (_ballPosition.dx + speedDiag < screenWidth - sizeBall - 20 &&
          _ballPosition.dy - speedDiag > sizeBall / 4) {
        _ballPosition =
            Offset(_ballPosition.dx + speedDiag, _ballPosition.dy - speedDiag);
      } else if (_ballPosition.dx + speedDiag >= screenWidth - sizeBall - 20 &&
          _ballPosition.dy - speedDiag <= sizeBall / 4) {
        _ballPosition = Offset(screenWidth - sizeBall - 10, 0 - sizeBall / 4);
      } else if (_ballPosition.dx + speedDiag >= screenWidth - sizeBall - 20) {
        _ballPosition =
            Offset(screenWidth - sizeBall - 10, _ballPosition.dy - speedDiag);
      } else {
        _ballPosition = Offset(_ballPosition.dx + speedDiag, 0 - sizeBall / 4);
      }
    } else if (x > 2.5 && y < 6) {
      // Droite haut
      if (_ballPosition.dx + speedDiag < screenWidth - sizeBall - 20 &&
          _ballPosition.dy + speedDiag <
              screenHeight - appBarHeight - sizeBall - 20) {
        _ballPosition =
            Offset(_ballPosition.dx + speedDiag, _ballPosition.dy + speedDiag);
      } else if (_ballPosition.dx + speedDiag >= screenWidth - sizeBall - 20 &&
          _ballPosition.dy + speedDiag >=
              screenHeight - appBarHeight - sizeBall - 20) {
        _ballPosition = Offset(screenWidth - sizeBall - 10,
            screenHeight - appBarHeight - sizeBall - 10);
      } else if (_ballPosition.dx + speedDiag >= screenWidth - sizeBall - 20) {
        _ballPosition =
            Offset(screenWidth - sizeBall - 10, _ballPosition.dy + speedDiag);
      } else {
        _ballPosition = Offset(_ballPosition.dx + speedDiag,
            screenHeight - appBarHeight - sizeBall - 10);
      }
    } else if (x < -2.5 && y > 8) {
      // Gauche bas
      if (_ballPosition.dx - speedDiag > 0 &&
          _ballPosition.dy - speedDiag > sizeBall / 4) {
        _ballPosition =
            Offset(_ballPosition.dx - speedDiag, _ballPosition.dy - speedDiag);
      } else if (_ballPosition.dx - speedDiag <= 0 &&
          _ballPosition.dy - speedDiag <= sizeBall / 4) {
        _ballPosition = Offset(0 - sizeBall / 4, 0 - sizeBall / 4);
      } else if (_ballPosition.dx - speedDiag <= 0) {
        _ballPosition = Offset(0 - sizeBall / 4, _ballPosition.dy - speedDiag);
      } else {
        _ballPosition = Offset(_ballPosition.dx - speedDiag, 0 - sizeBall / 4);
      }
    } else if (x < -2.5 && y < 6) {
      // Gauche haut
      if (_ballPosition.dx - speedDiag > 0 &&
          _ballPosition.dy + speedDiag <
              screenHeight - appBarHeight - sizeBall - 20) {
        _ballPosition =
            Offset(_ballPosition.dx - speedDiag, _ballPosition.dy + speedDiag);
      } else if (_ballPosition.dx - speedDiag <= 0 &&
          _ballPosition.dy + speedDiag >=
              screenHeight - appBarHeight - sizeBall - 20) {
        _ballPosition = Offset(
            0 - sizeBall / 4, screenHeight - appBarHeight - sizeBall - 10);
      } else if (_ballPosition.dx - speedDiag <= 0) {
        _ballPosition = Offset(0 - sizeBall / 4, _ballPosition.dy + speedDiag);
      } else {
        _ballPosition = Offset(_ballPosition.dx - speedDiag,
            screenHeight - appBarHeight - sizeBall - 10);
      }
    }

    if ((successPosition.dx - _ballPosition.dx).abs().round() <= sizeBall / 2 &&
        (successPosition.dy - _ballPosition.dy).abs().round() <= sizeBall / 2) {
      counter++;
      isVisible = false;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
