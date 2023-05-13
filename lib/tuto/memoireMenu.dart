import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/memoireNombres.dart';
import 'package:flutter_application_1/tuto/memoireLettres.dart';

class MemoirePage extends StatefulWidget {
  @override
  _MemoirePageState createState() => _MemoirePageState();
}

class _MemoirePageState extends State<MemoirePage> {
  
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
    ),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/danse.jpg"),
           alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              
              style: ElevatedButton.styleFrom(
                          backgroundColor:  Color(0xFF7F5644),
                          minimumSize: Size(190, 45),
                      maximumSize: Size(220, 50),
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), // couleur de fond personnalisée
              ),
                child: const Text('Nombres',style:TextStyle(color:Colors.white,fontSize: 15)),
                
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemoireNombresPage()),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                          backgroundColor:  Color(0xFF7F5644),
                          minimumSize: Size(190, 45),
                      maximumSize: Size(230, 50),
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), // couleur de fond personnalisée
              ),
              child: const Text('Lettres',style:TextStyle(color:Colors.white,fontSize: 15)),
              
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemoireLettresPage()),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}
