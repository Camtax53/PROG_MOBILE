import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Auth/auth.dart';

class ReactivitePage extends StatefulWidget {
  const ReactivitePage({super.key});

  @override
  _ReacitiviteState createState() => _ReacitiviteState();
}

class _ReacitiviteState extends State<ReactivitePage> {
  int score = 0;
  int activeButton = 0;
  int countdown = 10;
  int numberOfLines = 4;
  int numberOfColumns = 3;

  Map<String, String> recordPersoMap = {
    "react3x10": "",
    "react3x30": "",
    "react5x10": "",
    "react5x30": "",
  };

  User? user;
  String uid = "";
  CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('Reactivite');

  Future<int> getRecord() async {
    for (var cle in recordPersoMap.keys) {
      QuerySnapshot snapshotGame = await recordCollection
          .where('uid', isEqualTo: uid)
          .where('game', isEqualTo: cle)
          .get();
      if (snapshotGame.docs.isNotEmpty) {
        String record = snapshotGame.docs.first.get('score').toString();
        recordPersoMap[cle] = record;
      } else {
        recordPersoMap[cle] = "0";
      }
    }
    return 1;
  }

  Future<int> addNewUserIntoFirestore() async {
    for (var cle in recordPersoMap.keys) {
      QuerySnapshot snapshotGame = await recordCollection
          .where('uid', isEqualTo: uid)
          .where('game', isEqualTo: cle)
          .get();
      if (snapshotGame.docs.isEmpty) {
        await recordCollection.add({
          'uid': uid,
          'game': cle,
          'score': '0',
        });
      }
    }
    await getRecord();
    setState(() {
      recordPersoMap;
    });
    return 1;
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;

    addNewUserIntoFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Reactivite"),
      ),
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              Text("3x3"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updatedRecordMap = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameRoute(
                            numberOfLines: 3,
                            numberOfColumns: 3,
                            time: 10,
                            recordPersoMap: recordPersoMap,
                            gameName: "react3x10",
                          ),
                        ),
                      );
                      if (updatedRecordMap != null) {
                        setState(() {
                          recordPersoMap = updatedRecordMap;
                        });
                      }
                    },
                    child: Text("10"),
                  ),
                  const Icon(Icons.star, color: Colors.deepPurple),
                  Text(recordPersoMap["react3x10"]!,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.deepPurple)),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updatedRecordMap = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameRoute(
                            numberOfLines: 3,
                            numberOfColumns: 3,
                            time: 10,
                            recordPersoMap: recordPersoMap,
                            gameName: "react3x30",
                          ),
                        ),
                      );
                      if (updatedRecordMap != null) {
                        setState(() {
                          recordPersoMap = updatedRecordMap;
                        });
                      }
                    },
                    child: Text("30"),
                  ),
                  const Icon(Icons.star, color: Colors.deepPurple),
                  Text(recordPersoMap["react3x30"]!,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.deepPurple)),
                ],
              ),
            ],
          ),
          const VerticalDivider(
            width: 40, // espace horizontal autour de la ligne de séparation
            color: Colors.grey, // couleur de la ligne de séparation
            thickness: 5, // épaisseur de la ligne de séparation
            indent:
                5, // espace vertical avant le début de la ligne de séparation
            endIndent:
                570, // espace vertical après la fin de la ligne de séparation
          ),
          Column(
            children: [
              Text("5x5"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updatedRecordMap = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameRoute(
                            numberOfLines: 5,
                            numberOfColumns: 5,
                            time: 10,
                            recordPersoMap: recordPersoMap,
                            gameName: "react5x10",
                          ),
                        ),
                      );
                      if (updatedRecordMap != null) {
                        setState(() {
                          recordPersoMap = updatedRecordMap;
                        });
                      }
                    },
                    child: Text("10"),
                  ),
                  const Icon(Icons.star, color: Colors.deepPurple),
                  Text(recordPersoMap["react5x10"]!,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.deepPurple)),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final updatedRecordMap = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameRoute(
                            numberOfLines: 5,
                            numberOfColumns: 5,
                            time: 10,
                            recordPersoMap: recordPersoMap,
                            gameName: "react5x30",
                          ),
                        ),
                      );
                      if (updatedRecordMap != null) {
                        setState(() {
                          recordPersoMap = updatedRecordMap;
                        });
                      }
                    },
                    child: Text("30"),
                  ),
                  const Icon(Icons.star, color: Colors.deepPurple),
                  Text(recordPersoMap["react5x30"]!,
                      style: const TextStyle(
                          fontSize: 24, color: Colors.deepPurple)),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class GameRoute extends StatefulWidget {
  final int numberOfLines;
  final int numberOfColumns;
  final int time;
  final Map<String, String> recordPersoMap;
  final String gameName;

  const GameRoute({
    Key? key,
    required this.numberOfLines,
    required this.numberOfColumns,
    required this.time,
    required this.recordPersoMap,
    required this.gameName,
  }) : super(key: key);

  @override
  _GameRouteState createState() => _GameRouteState();
}

class _GameRouteState extends State<GameRoute> {
  late int numberOfLines;
  late int numberOfColumns;
  late int countdown;
  late Map<String, String> recordPersoMap;
  late String gameName;
  int activeButton = 0;
  int score = 0;
  String recordPerso = "0";

  User? user;
  String uid = "";
  CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('Reactivite');

  void addRecord(String game) async {
    QuerySnapshot snapshotGame = await recordCollection
        .where('game', isEqualTo: game)
        .where('uid', isEqualTo: uid)
        .get();
    String record = snapshotGame.docs.first.get('score').toString();
    // Si un document existe déjà avec cet UID, mettre à jour le premier document trouvé
    if (int.parse(record) < score && snapshotGame.docs.isNotEmpty) {
      recordPersoMap[game] = (score).toString();
      await snapshotGame.docs.first.reference.update({
        'score': score.toString(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    numberOfLines = widget.numberOfLines;
    numberOfColumns = widget.numberOfColumns;
    countdown = widget.time;
    recordPersoMap = widget.recordPersoMap;
    gameName = widget.gameName;
    activeButton = Random().nextInt(numberOfLines * numberOfColumns);
    uid = FirebaseAuth.instance.currentUser!.uid;

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          score;
          addRecord(gameName);
          recordPersoMap;
          timer.cancel();
        }
      });
    });
  }

  void _onBackPressed() {
    Navigator.pop(context, recordPersoMap);
  }

  @override
  Widget build(BuildContext context) {
    // Code de construction de l'interface graphique ici
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _onBackPressed,
        ),
        title: Text(widget.gameName),
      ),
      body: game(numberOfLines, numberOfColumns, countdown),
    );
  }

  void handleButtonPress(int buttonIndex) {
    if (buttonIndex == activeButton && countdown > 0) {
      setState(() {
        score++;
        activeButton = Random().nextInt(numberOfLines * numberOfColumns);
      });
    }
  }

  Widget game(int numberOfLines, int numberOfColumns, int time) {
    return Column(
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
    );
  }

  @override
  void dispose() {
    Navigator.pop(context, recordPersoMap);
    super.dispose();
  }
}
