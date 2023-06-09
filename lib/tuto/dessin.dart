import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<bool> endPoint = [];
double _strokeWidth = 5.0;

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.points, this.colors, this.strokeWidthList);

  final List<Offset> points;
  final List<Color> colors;
  final List<double> strokeWidthList;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero &&
          points[i + 1] != Offset.zero &&
          !endPoint[i]) {
        paint.color = colors[i];
        paint.strokeWidth = strokeWidthList[i];
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.colors != colors;
  }
}

class DessinPage extends StatefulWidget {
  @override
  _DessinPageState createState() => _DessinPageState();
}

class _DessinPageState extends State<DessinPage> {
  List<Offset> points = <Offset>[];
  List<Color> colors = <Color>[];
  List<double> strokeWidthList = [];

  void _addPoint(Offset point, Color color, double strokeWidth) {
    setState(() {
      points.add(point);
      colors.add(color);
      strokeWidthList.add(strokeWidth);
    });
    (context.findRenderObject() as RenderObject).markNeedsPaint();
  }

  Color _currentColor = Colors.black; // Couleur du pinceau
  bool firstPoint = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF09B198),
        title: const Text('Dessin '),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  points.clear();
                  colors.clear();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.color_lens),
              color:
                  _currentColor != Colors.white ? _currentColor : Colors.black,
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
                      actions: [
                        FilledButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.fluorescent_rounded),
              onPressed: () {
                setState(() {
                  _currentColor = Colors
                      .white; // Remplacez "_brushColor" par la variable qui contient la couleur de votre pinceau
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choisir la taille du crayon'),
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: _strokeWidth,
                                min: 1.0,
                                max: 20.0,
                                divisions: 19,
                                label: _strokeWidth.round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _strokeWidth = value;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      actions: [
                        FilledButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const Text('Dessine sur l\'écran avec ton doigt'),
          Expanded(
            child: GestureDetector(
              //dessine sur l'écran selon les mouvements du doigt
              onPanStart: (details) => setState(() {
                _addPoint(details.localPosition, _currentColor, _strokeWidth);
                endPoint.add(false);
              }),
              onPanUpdate: (details) => setState(() {
                _addPoint(details.localPosition, _currentColor, _strokeWidth);
                endPoint.add(false);
              }),
              onPanEnd: (details) => setState(() {
                _addPoint(Offset.zero, _currentColor, _strokeWidth);
                endPoint.add(true);
              }),
              child: CustomPaint(
                painter: DrawingPainter(points, colors, strokeWidthList),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _strokeWidth = 5.0;
    super.dispose();
  }
}
