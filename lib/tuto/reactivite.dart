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
  int numberOfLines = 10;
  int numberOfColumns = 10;

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
                return FilledButton(
                  onPressed: () => handleButtonPress(index),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      index == activeButton ? Colors.green : Colors.grey,
                    ),
                  ),
                  child: const Text(""),
                );
              }),
            ),
        ],
      ),
    );
  }
}
