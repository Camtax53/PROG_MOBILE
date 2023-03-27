import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'William Babin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Icon(
                Icons.add,
                size: 50.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                '$_counter',
                style: TextStyle(fontSize: 60, color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: _decrementCounter,
              child: const Icon(
                Icons.remove,
                size: 50.0,
              ),
            ),
          ],
        ),
        Column(
          children: [
            if (_controller.text == "Nono") Text("Wiwi") else Text("Bouh"),
            TextField(
              controller: _controller,
              onSubmitted: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: "Entrez du texte ici",
              ),
            ),
          ],
        )
      ]),
    );
  }
}
