
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/auth.dart';
import 'package:flutter_application_1/Auth/home_page.dart';
import 'package:flutter_application_1/Auth/login_register_page.dart';

import 'package:flutter_application_1/tuto/quizzTut.dart';
import 'package:flutter_application_1/tuto/reactivite.dart';
import 'package:flutter_application_1/tuto/labyrinthe.dart';
import 'package:flutter_application_1/tuto/dessin.dart';
import 'package:flutter_application_1/tuto/memoireMenu.dart';
import 'package:flutter_application_1/tuto/pompes.dart';





class MultiGame extends StatefulWidget {
  MultiGame({Key? key}) : super(key: key);



  @override
  State<MultiGame> createState() => _MultiGameState();
}


class _MultiGameState extends State<MultiGame> {
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Color(0xFF09B198),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout),
                color: Colors.white,
                onPressed: () {
                  signOut(context);
                },
              ),
            ),
          ),
        ],
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
            height: 290,
            width: 230,
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.2),
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10), bottom: Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}