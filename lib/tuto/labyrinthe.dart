import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LabyrinthePage extends StatefulWidget {
  const LabyrinthePage({super.key});

  @override
  _LabyrintheState createState() => _LabyrintheState();
}

class _LabyrintheState extends State<LabyrinthePage> {
  double _ballPositionX = 0.0;
  double _ballPositionY = 0.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Labyrinthe"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: _ballPositionX,
            bottom: _ballPositionY,
            child: Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.sports_volleyball,
                color: Colors.red,
                size: 50,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _ballPositionY -= 30;
                });
              },
              child: Text('Bas'),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _ballPositionY += 30;
                });
              },
              child: Text('Haut'),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_ballPositionX > 0) {
                    _ballPositionX -= 30;
                  }
                });
              },
              child: Text('Gauche'),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_ballPositionX < screenWidth - 60) {
                    _ballPositionX += 30;
                  }
                });
              },
              child: Text('Droite'),
            ),
          ),
        ],
      ),
    );
  }
}
