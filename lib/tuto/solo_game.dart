import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/auth.dart';
import 'package:flutter_application_1/Auth/home_page.dart';
import 'package:flutter_application_1/Auth/login_register_page.dart';
import 'package:flutter_application_1/Auth/widget_tree.dart';

import 'package:flutter_application_1/tuto/quizzTut.dart';
import 'package:flutter_application_1/tuto/reactivite.dart';
import 'package:flutter_application_1/tuto/labyrinthe.dart';
import 'package:flutter_application_1/tuto/dessin.dart';
import 'package:flutter_application_1/tuto/memoireMenu.dart';
import 'package:flutter_application_1/tuto/pompes.dart';

class SoloGame extends StatefulWidget {
  const SoloGame({Key? key}) : super(key: key);

  @override
  _SoloGameState createState() => _SoloGameState();
}

class _SoloGameState extends State<SoloGame> {
  double _buttonPosition = 0.0;

  Future<void> signOut(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFAF0D5),
          title: const Text(
            "Êtes-vous sûr de vouloir vous déconnecter?",
            style: TextStyle(
              color: Color(
                  0xFF09B198), // remplacez par votre couleur personnalisée
              fontSize:
                  20, // remplacez par votre taille de police personnalisée
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Annuler",
                style: TextStyle(
                  color:
                      Colors.black, // remplacez par votre couleur personnalisée
                  fontSize:
                      20, // remplacez par votre taille de police personnalisée
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                "Déconnexion",
                style: TextStyle(
                  color:
                      Colors.black, // remplacez par votre couleur personnalisée
                  fontSize:
                      20, // remplacez par votre taille de police personnalisée
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await Auth().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WidgetTree()),
          ),
        ),
      ),
      body: Stack(children: [
        Image.asset(
          "assets/fondecran.jpg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 325,
            width: 230,
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10), bottom: Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF09B198),
                      minimumSize: const Size(100, 30),
                      maximumSize: const Size(220, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10), // Ajustement de la marge horizontale
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          
                          child: Text(
                            'Quizz sur l\'athlétisme',
                            overflow: TextOverflow
                                .ellipsis, // ellipse en cas de dépassement
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFFAF0D5),
                                  content: const Text(
                                    'Ce quizz va tester tes connaissances en matière d\'athlétisme. Répond à cinq questions au hasard et obtient le meilleur score.',
                                  ),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF09B198),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizzPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      minimumSize: Size(100, 30),
                      maximumSize: Size(220, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reactivité'),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFFAF0D5),
                                  content: const Text(
                                      'Comme lors de l\'entrainemnt des pilotes automobiles ce jeu permet de tester ta réactivité. Il faut cliquer le plus rapidement possible sur les boutons verts qui vont s\'afficher dans le temps imparti.'),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF09B198),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReactivitePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      minimumSize: Size(100, 30),
                      maximumSize: Size(220, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Golf'),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFFAF0D5),
                                  content: const Text(
                                      'Utilise le positionnement de ton téléphone pour faire avancer la balle de golf jusqu\'au trou vert. Evite les trous rouge qui te feront perdre !'),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF09B198),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LabyrinthePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      minimumSize: Size(100, 30),
                      maximumSize: Size(220, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dessin'),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFFAF0D5),
                                  content: const Text(
                                      'Bienvenue sur une feuille de dessin. Laisse libre court à ton imagination. Tu pourras tout effacer, changer la taille et la couleur de ton pinceau ou utiliser la gomme. Amuse toi bien.'),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF09B198),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DessinPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      minimumSize: Size(100, 30),
                      maximumSize: Size(220, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pompes'),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFFAF0D5),
                                  content: const Text(
                                      'Un peu de sport? Place toi en position de pompe avec le téléphone en dessous de toi. Lance le jeu et c\'est parti ! Fait autant de pompes que tu veux.'),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF09B198),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PompesPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      minimumSize: Size(100, 30),
                      maximumSize: Size(220, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Memoire'),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFFAF0D5),
                                  content: const Text(
                                      'Pas de bonnes performance sportive sans entrainer ton cerveau. Choisi entre une suite de chiffre ou une suite de lettre. Ensuite tu verras s\'afficher pendant 3 secondes une suite de nombre (ou chiffre). Mémorise la et ensuite réécrit la. Un nombre d\'indice sont à ta disposition il permettent de rafficher la suite quelques instants. Bonne chance. '),
                                  actions: [
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF09B198),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MemoirePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
