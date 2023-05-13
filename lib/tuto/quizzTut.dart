import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/solo_game.dart';
import 'package:just_audio/just_audio.dart';
import '../Auth/widget_Tree.dart';
//import 'package:audioplayers/audioplayers.dart';

late List<Map<String, String>> countriesAndCapitals;
late int nombrequestion ;

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
  late AudioPlayer player;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
   player = AudioPlayer();
    nombrequestion = 0;
    countriesAndCapitals = [
      {
        'Quel homme détient les records du monde des 100m et 200m ? (nom de famille)':
            'Bolt'
      },
      {'Combien doit-on effectuer d\'épreuves dans le décathlon ?': '10'},
      {
        'Comment s\'appelle le bâton que l\'on se transmet dans les relais ?':
            'Temoin'
      },
      {
        'Quelle est la longueur d\'un tour de piste extérieur en mètres?': '400'
      },
      {'Vrai ou Faux: Un athlète doit-il obligatoirement porter des chaussures ?': 'Faux'},
      {
        'Qui est l\'actuel détenteur du record du monde du décathlon masculin ? (nom de famille)':
            'Mayer'
      },
      {
        'Pour les relais, de combien d\'athlètes se compose chaque équipe ?':
            '4'
      },
      {
        'Vrai ou Faux: Le saut à la perche est l’un des sports d’athlétisme les plus anciens au monde.':
            'Vrai'
      },
      {
        'Vrai ou Faux: Les juges olympiques doivent tenir compte du vent lorsqu’ils vérifient le résultat du saut en longueur.':
            'Vrai'
      },
      {'Quelle couleur manque pour compléter le drpaeau des JO: Bleu, rouge, jaune, vert et ...':'Noir'},
      {'Dans quelle ville seront organisé les JO 2024?':'Paris'}
    ];
    countriesAndCapitals.shuffle();
  }

@override
void dispose() {
  player.dispose();
  super.dispose();
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
            backgroundColor: const Color(0xFFFAF0D5),
            title: Text("Fin du jeu",style: TextStyle(color: Color(0xFF09B198),fontSize: 20),),
            content: Text("Votre score final est de: $_counter"),
            
            actions: [
              TextButton(
                child: Text('Retour à l\'accueil',style:TextStyle(color:Colors.black,fontSize: 15)),
                onPressed: () {
                  // Ferme la boîte de dialogue et retourne à la page précédente
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SoloGame()),
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
      resizeToAvoidBottomInset: false,
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
                          const SizedBox(height: 40),
                          SizedBox(
                            child: Text(countriesAndCapitals.first.keys.first,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 20),
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
                            ),
                          ),
                          const SizedBox(height: 20),
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
                            onPressed: () async {
                              nombrequestion++;
                              if (_controller.text.toLowerCase() ==
                                      countriesAndCapitals.first.values.first
                                          .toLowerCase() && answer == null) { //le if permet de voir si c'est la bonne réponse
                              await player.setAsset('assets/win.mp3');
                              player.play();
                                answer = true; 
                                _controller.clear();
                                _incrementCounter();
                              } else {
                                await player.setAsset('assets/fail.mp3');
                                _controller.clear();
                                player.play();
                                setState(() {
                                  answer = false;
                                });
                              }
                              setState(() {
                                if (nombrequestion < 5) { //compte 
                                  countriesAndCapitals.removeAt(0);
                                  showButton = false;
                                  answer = null;
                                } else if (nombrequestion == 5) {//permet de voir si c'est la fin des 5 question
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
