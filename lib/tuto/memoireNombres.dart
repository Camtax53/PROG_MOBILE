import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/tuto/solo_game.dart';

class MemoireNombresPage extends StatefulWidget {
  @override
  _MemoireNombresPageState createState() => _MemoireNombresPageState();
}

class _MemoireNombresPageState extends State<MemoireNombresPage> {
  bool isVisible = true;
  int round = 1;
  String inputText = "";
  String attente = "";
  String randomNumber = "";
  String recordPerso = "";
  int time = 3; // Temps restant
  int remainingHints = 3; // Nombre d'indices restants
  final TextEditingController _controller = TextEditingController();

  void addRandomNumber() {
    setState(() {
      Random random = Random();
      int randomInt = random.nextInt(10);
      randomNumber += randomInt.toString();
      attente += "?";
    });
  }

  void reset() {
    setState(() {
      isVisible = true;
      round = 1;
      inputText = "";
      attente = "";
      randomNumber = "";
      remainingHints = 3;
      addRandomNumber();
    });
  }

  User? user;
  String uid = "";
  CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('memoireNombres');

  void addRecord() async {
    QuerySnapshot snapshotUid =
        await recordCollection.where('uid', isEqualTo: uid).get();
    String record = snapshotUid.docs.first.get('score').toString();

    // Si un document existe déjà avec cet UID, mettre à jour le premier document trouvé
    if (int.parse(record) < round) {
      recordPerso = (round - 1).toString();
      await snapshotUid.docs.first.reference.update({
        'game': 'MemoireNombres',
        'score': round - 1,
      });
    }
  }

  void getRecord() async {
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
        'game': 'MemoireNombres',
        'score': '0',
      });
    }
    getRecord();
  }

  @override
  void initState() {
    super.initState();
    addRandomNumber();
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
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.withOpacity(0.2),
          title: const Text('Nombres'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 5),
              child: Container(
                height: 30,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  child: Text(
                    "Round $round",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ], //si je veux acceder au record perso c'est : Text(" $recordPerso", style: TextStyle(color: Colors.white))
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ballet.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: kToolbarHeight + 40, left: 20, right: 20),
              child: Column(children: [
                Visibility(
                  visible: isVisible,
                  child: Text("$randomNumber",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                Visibility(
                  visible: !isVisible,
                  child: Text("$attente",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Entrez votre texte',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )),
                  controller: _controller,
                  enabled: !isVisible,
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    setState(() {
                      inputText = value;

                      if (inputText == randomNumber && !isVisible) {
                        isVisible = true;
                        addRecord();
                        addRandomNumber();
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
                              title: const Row(
                                children: [
                                  Text("Perdu !"),
                                  SizedBox(width: 8),
                                  Icon(Icons.filter_vintage_outlined,
                                      color: Colors.grey),
                                ],
                              ),
                              content: Text("Vous avez perdu la partie."),
                              backgroundColor: Colors.white,
                              actions: <Widget>[
                                ButtonBar(
                                  children: [
                                    ElevatedButton(
                                      // child: Text("Accueil"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .grey, // couleur de fond personnalisée
                                      ),
                                      child: const Text('Accueil',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const SoloGame()),
                                          (Route<dynamic> route) =>
                                              false, // Cette fonction empêche la navigation en arrière
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .grey, // couleur de fond personnalisée
                                      ),
                                      child: const Text('Restart',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
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
                Align(
                  alignment: Alignment.topLeft,
                  
                  child: ElevatedButton(
                    //indice
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCFD3D6), // couleur de fond personnalisée
                    ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                         
                          child: const Text(
                            'Indice',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (remainingHints > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFCB2D),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                remainingHints.toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ]),
            )));
  }
}
