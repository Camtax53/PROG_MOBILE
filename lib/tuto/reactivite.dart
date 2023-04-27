import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ReactivitePage extends StatefulWidget {
  @override
  _ReacitiviteState createState() => _ReacitiviteState();
}

class _ReacitiviteState extends State<ReactivitePage> {
  int score = 0;
  int activeButton = 0;
  int countdown = 10;
  int numberOfLines = 4;
  int numberOfColumns = 3;

  void handleButtonPress(int buttonIndex) {
    if (buttonIndex == activeButton && countdown > 0) {
      setState(() {
        score++;
        activeButton = Random().nextInt(numberOfLines * numberOfColumns);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    activeButton = Random().nextInt(numberOfLines * numberOfColumns);

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Reactivite"),
      ),
      body: Column(
        children: [
          Text(
            "Temps restant: $countdown secondes",
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            "Score: $score",
            style: const TextStyle(fontSize: 24),
          ),
          if (countdown == 0)
            const Text(
              "Fin du jeu",
              style: TextStyle(fontSize: 24),
            ),
          if (countdown > 0)
            GridView.count(
              crossAxisCount: numberOfColumns,
              shrinkWrap: true,
              children: List.generate(numberOfColumns * numberOfLines, (index) {
                return IconButton(
                  onPressed: () => handleButtonPress(index),
                  icon: Icon(
                      index == activeButton
                          ? Icons.sports_soccer
                          : Icons.sports_basketball,
                      size: 60.0,
                      color:
                          index == activeButton ? Colors.black : Colors.orange),
                );
              }),
            ),
        ],
      ),
    );
  }
}
