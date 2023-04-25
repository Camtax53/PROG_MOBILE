import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MemoireNombresPage extends StatefulWidget {
  @override
  _MemoireNombresPageState createState() => _MemoireNombresPageState();
}

class _MemoireNombresPageState extends State<MemoireNombresPage> {
  bool isVisible = true;
  int round = 0;
  String inputText = "";
  String attente = "";
  String randomNumber = "";
  final TextEditingController _controller = TextEditingController();

  void addRandomNumber() {
    setState(() {
      Random random = Random();
      int randomInt = random.nextInt(10);
      randomNumber += randomInt.toString();
      attente += "?";
    });
  }

  @override
  void initState() {
    super.initState();
    addRandomNumber();
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
          child: Text("$randomNumber", style: TextStyle(fontSize: 24)),
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
              } else if (inputText == randomNumber && !isVisible) {
                round++;
                isVisible = true;
                addRandomNumber();
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
