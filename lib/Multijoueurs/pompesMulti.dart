import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter_application_1/tuto/multi_game.dart';

int counterA = 0;

class PompesPage extends StatefulWidget {
  const PompesPage({Key? key});

  @override
  _PompesState createState() => _PompesState();

  //recupere le nombre de pompes de l'autre joueur
  static void receiveCount(int count) {
    counterA = count;
  }

  static of(BuildContext context) {}
}

class _PompesState extends State<PompesPage> {
  late StreamSubscription<int> _streamSubscription;
  bool _isNear = false;
  bool _isCounting = false;
  int _counter = 0;
  late Timer _timer;
  int countdown = 10;
  int counterMilli = 0;
  late AudioPlayer player;

  void _startCounting() {
    if (!_isCounting) {
      _isCounting = true;
      _counter++;
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _isCounting = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _startTimer();
    listenSensor();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      sendCountToOtherFile();
      setState(() {
        counterA;
        if (counterMilli == 1000 && countdown > 0) {
          counterMilli = 0;
          countdown--;
        } else {
          counterMilli += 200;
        }
        if (countdown == 0 && counterA > _counter) {
          player.setAsset('assets/sons/ko.mp3');
          player.play();
          timer.cancel();
        } else if (countdown == 0 && counterA < _counter) {
          player.setAsset('assets/sons/winBoxe.mp3');
          player.play();
          timer.cancel();
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void listenSensor() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        if (event > 0 && !_isNear) {
          _isNear = true;
          _startCounting();
        } else {
          _isNear = false;
        }
      });
    });
  }

  void sendCountToOtherFile() {
    // Appel de la fonction de rappel avec la valeur `_counter`
    MultiGame.receiveCount(_counter);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    player.dispose();
    _stopTimer();
    counterA = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          if (countdown > 0)
            Image.asset(
              "assets/image/pompes.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          if (countdown > 0)
            Align(
              alignment: Alignment.center,
              child: Text(
                  '                    $countdown\n\n Nombre de pompes :  $_counter\n      Autre joueur: $counterA',
                  style: const TextStyle(fontSize: 15)),
            ),
          if (countdown == 0 && counterA > _counter)
            Image.asset(
              "assets/image/losingboxe.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          if (countdown == 0 && counterA > _counter)
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Fin du jeu!",
                    style: TextStyle(fontSize: 24, color: Color(0xFFA62C41)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFFA62C41), // couleur de fond personnalisée
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
            ),
          if (countdown == 0 && counterA < _counter)
            Image.asset(
              "assets/image/winningBoxe.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          if (countdown == 0 && counterA < _counter)
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    "Fin du jeu!",
                    style: TextStyle(fontSize: 24, color: Color(0xFFA62C41)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFFA62C41), // couleur de fond personnalisée
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
            ),
        ],
      ),
    );
  }
}
