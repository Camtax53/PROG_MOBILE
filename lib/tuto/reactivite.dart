import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Auth/auth.dart';
import 'package:flutter_application_1/tuto/solo_game.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.2),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/startingblockf1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 100),
            
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Défilement horizontal
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 230),
              Column(
                children: [
                  const Text(
                    "Taille 3x3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // texte en gras
                      fontSize: 20, // taille du texte augmentée à 20
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(
                              0xFFC21723), // couleur de fond personnalisée
                        ),
                        child: const Text("10 sec"),
                      ),
                      const Icon(Icons.emoji_events, color: Colors.black),
                      Text(recordPersoMap["react3x10"]!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
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
                                time: 30,
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(
                              0xFFC21723), // couleur de fond personnalisée
                        ),
                        child: const Text("30 sec"),
                      ),
                      const Icon(Icons.emoji_events, color: Colors.black),
                      Text(recordPersoMap["react3x30"]!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const VerticalDivider(
                width: 40, // espace horizontal autour de la ligne de séparation
                color: Colors.black, // couleur de la ligne de séparation
                thickness: 10, // épaisseur de la ligne de séparation
                indent:
                    5, // espace vertical avant le début de la ligne de séparation
                endIndent:
                    570, // espace vertical après la fin de la ligne de séparation
              ),
              Column(
                children: [
                  const Text(
                    "Taille 5x5",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // texte en gras
                      fontSize: 20, // taille du texte augmentée à 20
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(
                              0xFFC21723), // couleur de fond personnalisée
                        ),
                        child: const Text("10 sec"),
                      ),
                      const Icon(Icons.emoji_events, color: Colors.black),
                      Text(recordPersoMap["react5x10"]!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
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
                                time: 30,
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(
                              0xFFC21723), // couleur de fond personnalisée
                        ),
                        child: const Text("30 sec"),
                      ),
                      const Icon(Icons.emoji_events, color: Colors.black),
                      Text(recordPersoMap["react5x30"]!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ]
            ),),
          )
      ),
    );
  }
}


//nouvelle classe pr le jeu
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
    extendBodyBehindAppBar: true,
    appBar: AppBar(
       backgroundColor: Colors.blueGrey.withOpacity(0.2), // rendre la barre d'applications transparente
      actions: [
        Padding(
              padding: const EdgeInsets.only(right: 20, top: 5),
              child: Container(
                height: 30,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.amber[800],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  child: Text(
                    "Score: $score" ,
                    style: const TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _onBackPressed,
      ),
    ),
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/f1fond.jpg'),
          fit: BoxFit.cover, // ajuster l'image pour remplir tout l'écran
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top:10),
        child: Stack(children: [game(numberOfLines, numberOfColumns, countdown)]),
      ),
    ),
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
    return ListView(
      children: [
        Text.rich(
  TextSpan(
    text: 'Temps restant: ',
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    children: [
      TextSpan(
        text: '$countdown',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.amber[800],
        ),
      ),
      const TextSpan(
        text: ' secondes',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
),
        if (countdown == 0)
           Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Fin du jeu!",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFFC21723), // couleur de fond personnalisée
                        ),
                child: const Text('Retour à l\'accueil',style:TextStyle(color:Colors.white,fontSize: 15)),
                onPressed: () {
                  // Ferme la boîte de dialogue et retourne à la page précédente
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const SoloGame()),
                    (Route<dynamic> route) =>
                        false, // Cette fonction empêche la navigation en arrière
                  );
                },
              ),
          ],
        ),
        if (countdown > 0)
          GridView.count(
            crossAxisCount: numberOfColumns,
            shrinkWrap: true,
            children: List.generate(numberOfColumns * numberOfLines, (index) {
              return IconButton(
                onPressed: () => handleButtonPress(index),
                icon: Image.asset(
                  index == activeButton
                      ? 'assets/image/boutongreen.png'
                      : 'assets/image/boutonred.png',
                  height: 90.0,
                  width: 90.0,
                ),
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
