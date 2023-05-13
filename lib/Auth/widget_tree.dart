import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/auth.dart';
import 'package:flutter_application_1/Auth/home_page.dart';
import 'package:flutter_application_1/Auth/login_register_page.dart';

import 'package:permission_handler/permission_handler.dart';
import '../tuto/multi_game.dart';
import '../tuto/solo_game.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage(
            //on est connecte donc on va sur myhomepage
            title: 'Games',
          );
        } else {
          return const LoginPage(); //si pas connecté va sur la login page
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  // void _onVerticalDragUpdate(DragUpdateDetails details) {
  //   setState(() {
  //     _buttonPosition += details.delta.dy;
  //     if (_buttonPosition < 0) {
  //       _buttonPosition = 0;
  //     } else if (_buttonPosition > 200) {
  //       _buttonPosition = 200;
  //     }
  //   });
  // }

  // Widget _signOutButton() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: Colors.white,
  //       backgroundColor: Colors.blueGrey,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       minimumSize: const Size(200, 40),
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     ),
  //     onPressed: signOut(context),
  //     child: const Text('Sign Out'),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // L'autorisation a été accordée, vous pouvez continuer
    } else {
      // L'autorisation a été refusée. Vous pouvez gérer ce cas en affichant un message d'information ou en demandant à nouveau l'autorisation.
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
            height: 100,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(200, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    child: const Text('Multijoueur'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MultiGame()),
                      );
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF09B198),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(200, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    child: const Text('Solo'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SoloGame()),
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
