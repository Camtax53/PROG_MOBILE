import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MemoireLettresPage extends StatefulWidget {
  @override
  _MemoireLettresPageState createState() => _MemoireLettresPageState();
}

class _MemoireLettresPageState extends State<MemoireLettresPage> {
  bool isVisible = true;
  int round = 0;
  String inputText = "";
  String attente = "";
  String randomLetter = "";
  final TextEditingController _controller = TextEditingController();

  void addRandomLetter() {
    setState(() {
      Random random = Random();
      int randomInt = random.nextInt(26);
      randomLetter += String.fromCharCode(randomInt + 97);
      attente += "?";
    });
  }

  @override
  void initState() {
    super.initState();
    addRandomLetter();
    Timer(Duration(seconds: 5), () {
      setState(() {
        isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('MemoireNombres'),
      ),
      body: Column(children: [
        Text("\n Round $round \n\n", style: TextStyle(fontSize: 24)),
        Visibility(
          visible: isVisible,
          child: Text("$randomLetter", style: TextStyle(fontSize: 24)),
        ),
        Visibility(
          visible: !isVisible,
          child: Text("$attente", style: TextStyle(fontSize: 24)),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Entrez votre texte',
            border: OutlineInputBorder(),
          ),
          controller: _controller,
          onSubmitted: (value) {
            setState(() {
              inputText = value;

              if (isVisible) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title:
                          Text("Vous devez attendre que le nombre soit caché")),
                );
              } else if (inputText == randomLetter && !isVisible) {
                round++;
                isVisible = true;
                addRandomLetter();
                Timer(Duration(seconds: 5), () {
                  setState(() {
                    isVisible = false;
                  });
                });
              }
            });
            _controller.clear();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.access_time, size: 30),
          onPressed: () {
            // code à exécuter lorsque l'utilisateur appuie sur le bouton
            setState(() {
              isVisible = true;
              Timer(Duration(seconds: 5), () {
                setState(() {
                  isVisible = false;
                });
              });
            });
          },
        ),
      ]),
    );
  }
}
