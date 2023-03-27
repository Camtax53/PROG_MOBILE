import 'package:flutter/material.dart';

List<Map<String, String>> countriesAndCapitals = [
  {'France': 'Paris'},
  {'Germany': 'Berlin'},
  {'United Kingdom': 'London'},
  {'United States': 'Washington'},
  {'Russia': 'Moscow'},
  {'Japan': 'Tokyo'},
  {'China': 'Beijing'},
  {'Italie': 'Rome'},
  {'Australia': 'Canberra'},
  {'South Africa': 'Pretoria'},
];

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
    countriesAndCapitals.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Quizz"),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Text(
                "Quelle est la capitale de " +
                    countriesAndCapitals.first.keys.first,
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 5,
            child: answer == true
                ? const Icon(
                    Icons.check,
                    size: 50.0,
                    color: Colors.greenAccent,
                  ) // Si answer est vrai, afficher l'icône "check"
                : answer == false
                    ? const Icon(Icons.close, size: 50.0, color: Colors.red)
                    : const Text(""),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "Score: " + "$_counter",
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              style: TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                  hintText: "Entrez votre réponse ici",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.deepPurple),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )),
              textAlign: TextAlign.center,
              controller: _controller,
              onSubmitted: (String value) {
                if (_controller.text.toLowerCase() ==
                        countriesAndCapitals.first.values.first.toLowerCase() &&
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
          const Expanded(child: Text("")),
          if (countriesAndCapitals.length > 1 && showButton == true)
            ElevatedButton(
              child: const Text('Question suivante'),
              onPressed: () {
                // code à exécuter lorsque l'utilisateur appuie sur le bouton
                setState(() {
                  countriesAndCapitals.removeAt(0);
                  showButton = false;
                  answer = null;
                });
              },
            ),
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
