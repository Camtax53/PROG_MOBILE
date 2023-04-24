import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<bool> endPoint = [];

class DessinPage extends StatefulWidget {
  @override
  _DessinPageState createState() => _DessinPageState();
}

class _DessinPageState extends State<DessinPage> {
  List<Offset> _points = <Offset>[];
  List<Color> _colors = <Color>[];

  Color _currentColor = Colors.black; // Couleur du pinceau
  bool firstPoint = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Dessin '),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _points.clear();
                  _colors.clear();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choisir une couleur'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: _currentColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              _currentColor = color;
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        //dessine sur l'écran selon les mouvements du doigt
        onPanStart: (details) => setState(() {
          _points.add(details.localPosition);
          _colors.add(_currentColor);
          endPoint.add(false);
        }),
        onPanUpdate: (details) => setState(() {
          if (firstPoint) {
            _points.add(details.localPosition);
            _colors.add(_currentColor);
            endPoint.add(false);
            firstPoint = false;
          } else {
            _points.add(details.localPosition);
            _colors.add(_currentColor);
            endPoint.add(false);
          }
        }),
        onPanEnd: (details) => setState(() {
          _points.add(Offset.zero);
        }),

        child: CustomPaint(
          painter: DrawingPainter(_points, _colors),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.points, this.colors);

  final List<Offset> points;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        paint.color = colors[i];
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.colors != colors;
  }
}
