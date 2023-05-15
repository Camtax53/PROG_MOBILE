import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/multi_game.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<bool> endPoint = [];
double _strokeWidth = 5.0;
List<Offset> points = <Offset>[];
List<Color> colors = <Color>[];
List<String> drawList = [];
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

  static void receiveList(List<String> draw) {
    drawList = draw;

    print(drawList);
  }
}

class _DessinViewPageState extends State<DessinViewPage> {
  late Timer _timer;
  final TextEditingController _controller = TextEditingController();
  List<String> adrawList = ['caca'];
  int countdown = 11;
  int score = 0;
  int counterMilli = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    points = [];
    colors = [];
    strokeWidthList = [];
    drawList = [];
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        points;
        colors;
        strokeWidthList;
        if (counterMilli == 1000 && countdown > 0) {
          counterMilli = 0;
          countdown--;
        } else {
          counterMilli += 200;
        }

        print(drawList);
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
      appBar: AppBar(title: Text("Score : " + score.toString()), actions: [
        Text(countdown.toString()),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            if (_controller.text == drawList.first) {
              print("Bonne réponse");
              score++;
              points = [];
              colors = [];
              strokeWidthList = [];
              drawList.removeAt(0);
              MultiGame.sendResult(true);
              _controller.clear();
            } else {
              print("Mauvaise réponse");
            }
          },
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: TextField(
          style: TextStyle(fontSize: 15),
          decoration: const InputDecoration(
              hintText: "Entrez votre réponse ici",
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Color(0xFF09B198)),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
          textAlign: TextAlign.center,
          controller: _controller,
        ),
      ),
      body: Column(
        children: [
          if (countdown > 0)
            Expanded(
              child: CustomPaint(
                painter: DrawingPainter(
                  points,
                  colors,
                  strokeWidthList,
                ),
              ),
            ),
          if (countdown == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Fin du jeu!",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFFC21723), // couleur de fond personnalisée
                  ),
                  child: const Text('Retour à l\'accueil',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  onPressed: () {
                    // Ferme la boîte de dialogue et retourne à la page précédente
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MultiGame()),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
