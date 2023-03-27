import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LabyrinthePage extends StatefulWidget {
  const LabyrinthePage({super.key});

  @override
  _LabyrintheState createState() => _LabyrintheState();
}

class _LabyrintheState extends State<LabyrinthePage> {
  double _ballPosition = 0.0;
  double _ballVelocity = 0.0;
  double _ballAcceleration = 1;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _ballVelocity = -15.0;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _ballVelocity = 15.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Labyrinthe'),
      ),
      body: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 50),
          child: Icon(Icons.sports_volleyball, size: 50.0, color: Colors.red),
          width: 50.0,
          height: 50.0,
          margin: EdgeInsets.only(top: _ballPosition),
          onEnd: () {
            setState(() {
              _ballVelocity += _ballAcceleration;
              _ballPosition += _ballVelocity;
            });
          },
        ),
      ),
    );
  }
}
