import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/multi_game.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<bool> endPoint = [];
double _strokeWidth = 5.0;
List<Offset> points = <Offset>[];
List<Color> colors = <Color>[];
List<double> strokeWidthList = [];

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final List<Color> colors;
  final List<double> strokeWidthList;

  DrawingPainter(this.points, this.colors, this.strokeWidthList);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        paint.color = colors[i];
        paint.strokeWidth = strokeWidthList[i];
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.colors != colors ||
        oldDelegate.strokeWidthList != strokeWidthList;
  }
}

class DessinViewPage extends StatefulWidget {
  @override
  _DessinViewPageState createState() => _DessinViewPageState();

  static void receiveDraw(List<Offset> _points, List<Color> _colors,
      List<double> _strokeWidthList) {
    points = _points;
    colors = _colors;
    strokeWidthList = _strokeWidthList;

    print(points);

    // Effectuez d'autres opérations avec la valeur `_count` ici
  }
}

class _DessinViewPageState extends State<DessinViewPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    counterA = 0;
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        points;
        colors;
        strokeWidthList;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: DrawingPainter(
                points,
                colors,
                strokeWidthList,
              ),
              child:
                  Container(), // Remplacez par le contenu que vous souhaitez afficher
            ),
          ),
          // Autres éléments de votre interface utilisateur ici
        ],
      ),
    );
  }
}
