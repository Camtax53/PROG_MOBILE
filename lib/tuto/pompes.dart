import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class PompesPage extends StatefulWidget {
  const PompesPage({Key? key});

  @override
  _PompesState createState() => _PompesState();
}

class _PompesState extends State<PompesPage> {
  late StreamSubscription<int> _streamSubscription;
  bool _isNear = false;
  bool _isCounting = false;
  int _counter = 0;

  void _startCounting() {
    if (!_isCounting) {
      _isCounting = true;
      _counter++;
      Timer(Duration(seconds: 1), () {
        setState(() {
          _isCounting = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listenSensor();
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

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Pompes'),
        ),
        body: Center(
          child: Text('Nombre de pompes :  $_counter\n'),
        ),
      ),
    );
  }
}
