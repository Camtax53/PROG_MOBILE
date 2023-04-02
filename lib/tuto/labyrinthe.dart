import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LabyrinthePage extends StatefulWidget {
  const LabyrinthePage({Key? key});

  @override
  _LabyrintheState createState() => _LabyrintheState();
}

class _LabyrintheState extends State<LabyrinthePage> {
  double _ballPositionX = 0.0;
  double _ballPositionY = 0.0;
  double sizeBall = 30.0;
  double speed = 50.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Labyrinthe"),
      ),
      body: Stack(
        children: [
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
          Positioned(
            bottom: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_ballPositionY - speed > sizeBall / 4) {
                    _ballPositionY -= speed;
                  } else {
                    _ballPositionY = 0 - sizeBall / 4;
                  }
                  print(_ballPositionY);
                });
              },
              child: const Text('Bas'),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_ballPositionY + speed <
                      screenHeight - appBarHeight - sizeBall - 20) {
                    _ballPositionY += speed;
                  } else {
                    _ballPositionY =
                        screenHeight - appBarHeight - sizeBall - 10;
                  }
                  print(_ballPositionY);
                });
              },
              child: const Text('Haut'),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_ballPositionX - speed > 0) {
                    _ballPositionX -= speed;
                  } else {
                    _ballPositionX = 0 - sizeBall / 4;
                  }
                  print(_ballPositionX);
                });
              },
              child: const Text('Gauche'),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_ballPositionX + speed < screenWidth - sizeBall - 20) {
                    _ballPositionX += speed;
                  } else {
                    _ballPositionX = screenWidth - sizeBall - 10;
                  }
                  print(_ballPositionX);
                });
              },
              child: const Text('Droite'),
            ),
          ),
        ],
      ),
    );
  }
}
