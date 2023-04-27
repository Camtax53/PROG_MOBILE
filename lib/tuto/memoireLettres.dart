import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemoireLettresPage extends StatefulWidget {
  @override
  _MemoireLettresPageState createState() => _MemoireLettresPageState();
}

class _MemoireLettresPageState extends State<MemoireLettresPage> {
  bool isVisible = true;
  int round = 1;
  String inputText = "";
  String attente = "";
  String randomLetter = "";
  String recordPerso = "";
  int time = 3; // Temps restant
  int remainingHints = 3; // Nombre d'indices restants
  final TextEditingController _controller = TextEditingController();

  void addRandomLetter() {
    setState(() {
      Random random = Random();
      int randomInt = random.nextInt(26);
      randomLetter += String.fromCharCode(randomInt + 97);
      attente += "?";
    });
  }

  void reset() {
    setState(() {
      isVisible = true;
      round = 1;
      inputText = "";
      attente = "";
      randomLetter = "";
      remainingHints = 3;
      addRandomLetter();
    });
  }

  User? user;
  String uid = "";
  CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('memoireLettres');

  void addRecord() async {
    QuerySnapshot snapshotUid =
        await recordCollection.where('uid', isEqualTo: uid).get();
    String record = snapshotUid.docs.first.get('score').toString();

    // Si un document existe déjà avec cet UID, mettre à jour le premier document trouvé
    if (int.parse(record) < round) {
      recordPerso = (round - 1).toString();
      await snapshotUid.docs.first.reference.update({
        'game': 'MemoireLettres',
        'score': round - 1,
      });
    }
  }

  void setRecord() async {
    QuerySnapshot snapshotUid =
        await recordCollection.where('uid', isEqualTo: uid).get();
    String record = snapshotUid.docs.first.get('score').toString();

    setState(() {
      if (snapshotUid.docs.isNotEmpty) {
        recordPerso = record;
      } else {
        recordPerso = "0";
      }
    });
  }

  void addNewUserIntoFirestore() async {
    QuerySnapshot snapshotUid =
        await recordCollection.where('uid', isEqualTo: uid).get();
    if (snapshotUid.docs.isEmpty) {
      await recordCollection.add({
        'uid': uid,
        'game': 'MemoireLettres',
        'score': '0',
      });
    }
    setRecord();
  }

  @override
  void initState() {
    super.initState();
    addRandomLetter();
    user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;
    addNewUserIntoFirestore();

    Timer(Duration(seconds: time), () {
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
          title: const Text('MemoireLettres'),
          actions: <Widget>[
            const Icon(Icons.emoji_events, color: Colors.white),
            Text(" $recordPerso", style: TextStyle(color: Colors.white)),
            const Icon(Icons.star, color: Colors.deepPurple),
          ]),
      body: Column(children: [
        Text("\n Round $round \n\n", style: TextStyle(fontSize: 24)),
        Visibility(
          visible: isVisible,
          child: Text("$randomLetter", style: TextStyle(fontSize: 24)),
        ),
        Visibility(
          visible: !isVisible,
          child: Text("$attente", style: const TextStyle(fontSize: 24)),
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Entrez votre texte',
            border: OutlineInputBorder(),
          ),
          controller: _controller,
          enabled: !isVisible,
          onSubmitted: (value) {
            setState(() {
              inputText = value;

              if (inputText == randomLetter && !isVisible) {
                isVisible = true;
                addRecord();
                addRandomLetter();
                round++;
                Timer(Duration(seconds: time), () {
                  setState(() {
                    isVisible = false;
                  });
                });
                if (round % 5 == 0) {
                  remainingHints++;
                }
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Perdu !"),
                      content: Text("Vous avez perdu la partie."),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            reset();
                            Timer(Duration(seconds: time), () {
                              setState(() {
                                isVisible = false;
                              });
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            });
            _controller.clear();
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (remainingHints > 0) {
                isVisible = true;
                remainingHints--;

                Timer(Duration(seconds: time), () {
                  setState(() {
                    isVisible = false;
                  });
                });
              }
            });
          },
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text('Indice'),
              ),
              if (remainingHints > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      remainingHints.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
