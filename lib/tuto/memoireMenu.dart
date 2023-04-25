import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/memoireNombres.dart';
import 'package:flutter_application_1/tuto/memoireLettres.dart';

class MemoirePage extends StatefulWidget {
  @override
  _MemoirePageState createState() => _MemoirePageState();
}

class _MemoirePageState extends State<MemoirePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Memoire'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Memoire Nombres'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemoireNombresPage()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Mémoire Lettres'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemoireLettresPage()),
                  );
                },
              ),
            ]),
      ),
    );
  }
}
