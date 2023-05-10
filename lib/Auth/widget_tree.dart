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
            title: 'Games',
          );
        } else {
          return const LoginPage();
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
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Quizz Capitales'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizzPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Reactivité'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReactivitePage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Labyrinthe'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LabyrinthePage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Pompes'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PompesPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Dessin'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DessinPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Memoire'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemoirePage()),
                );
              },
            ),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
