import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/multi_game.dart';

int counterA = 0;

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();

  static void receiveCount(int count) {
    // Utilisez la valeur `_count` comme vous le souhaitez
    print('Received count from MultiPage: $count');

    counterA = count;

    // Effectuez d'autres opérations avec la valeur `_count` ici
  }

  static of(BuildContext context) {}
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;
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
        counterA;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void increment() {
    setState(() {
      _count++;
      counterA;
    });
  }

  void sendCountToOtherFile() {
    // Appel de la fonction de rappel avec la valeur `_count`
    MultiGame.receiveCount(_count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter Value:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_count',
              style: TextStyle(fontSize: 50),
            ),
            Text('Autre joueur: $counterA')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          increment();
          sendCountToOtherFile(); // Appel de la fonction pour envoyer la valeur
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
