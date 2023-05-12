import 'package:flutter/material.dart';

import '../Auth/widget_Tree.dart';

late List<Map<String, String>> countriesAndCapitals;

class QuizzPage extends StatefulWidget {
  @override
  _QuizzPageState createState() => _QuizzPageState();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class _QuizzPageState extends State<QuizzPage> {
  int _counter = 0;
  bool? answer = null;
  bool showButton = false;

  final TextEditingController _controller = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    countriesAndCapitals = [
      {'1': 'Paris'},
      {'2': 'Berlin'},
      {'3': 'London'},
      {'4': 'Washington'},
      {'5': 'Moscow'},
      {'6': 'Tokyo'},
      {'7': 'Beijing'},
      {'8': 'Rome'},
      {'9': 'Canberra'},
      {'10': 'Pretoria'},
    ];
    countriesAndCapitals.shuffle();
  }

  void _showEndGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Retourner false pour empêcher la fermeture de la boîte de dialogue lors de l'appui sur le bouton Retour physique
            return false;
          },
          child: AlertDialog(
            title: Text("Retour à l'accueil"),
            content: Text("Êtes-vous sûr de vouloir retourner à l'accueil ?"),
            actions: [
              TextButton(
                child: Text('Retour à l\'accueil'),
                onPressed: () {
                  // Ferme la boîte de dialogue et retourne à la page précédente
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => WidgetTree()),
                    (Route<dynamic> route) =>
                        false, // Cette fonction empêche la navigation en arrière
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFF09B198), size: 30.0),
          backgroundColor: Colors.blueGrey.withOpacity(0.2),
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 5),
              child: Container(
                height: 35,
                width: 110,
                decoration: BoxDecoration(
                  color: Color(0xFF09B198),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  child: Text(
                    "Score: " + "$_counter",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ]),
      body: Stack(children: [
        Image.asset(
          "assets/running.jpg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                    height: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 40),
                          SizedBox(
                            child: Text(
                                "Quelle est la capitale de " +
                                    countriesAndCapitals.first.keys.first,
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            child: answer == true
                                ? const Icon(
                                    Icons.check,
                                    size: 50.0,
                                    color: Colors.greenAccent,
                                  ) // Si answer est vrai, afficher l'icône "check"
                                : answer == false
                                    ? const Icon(Icons.close,
                                        size: 50.0, color: Colors.red)
                                    : const Text(""),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            child: TextField(
                              style: TextStyle(fontSize: 15),
                              decoration: const InputDecoration(
                                  hintText: "Entrez votre réponse ici",
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Color(0xFF09B198)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              textAlign: TextAlign.center,
                              controller: _controller,
                              onSubmitted: (String value) {
                                if (_controller.text.toLowerCase() ==
                                        countriesAndCapitals.first.values.first
                                            .toLowerCase() &&
                                    answer == null) {
                                  answer = true;
                                  showButton = true;
                                  _controller.clear();
                                  _incrementCounter();
                                } else {
                                  setState(() {
                                    answer = false;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF09B198),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(200, 40),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            child: const Text('Valider ma réponse'),
                            onPressed: () {
                              // code à exécuter lorsque l'utilisateur appuie sur le bouton
                              setState(() {
                                if (countriesAndCapitals.length > 1) {
                                  countriesAndCapitals.removeAt(0);
                                  showButton = false;
                                  answer = null;
                                  print("caca");
                                } else if (countriesAndCapitals.length == 1) {
                                  _showEndGameDialog(context);
                                }
                              });
                            },
                          ),
                        ]))))
      ]),
    );
  }
}
