import 'package:flutter/material.dart';
import 'package:flutter_application_1/tuto/memoireNombres.dart';
import 'package:flutter_application_1/tuto/memoireLettres.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemoirePage extends StatefulWidget {
  @override
  _MemoirePageState createState() => _MemoirePageState();
}

class _MemoirePageState extends State<MemoirePage> {
  String nombreRecordPerso="";
  String lettresRecordPerso="";

User? user;
String uid = "";

CollectionReference recordNombreCollection =
    FirebaseFirestore.instance.collection('memoireNombres');

CollectionReference recordLettreCollection =
    FirebaseFirestore.instance.collection('memoireLettres');

Future<int> getRecordLettre() async {
      QuerySnapshot snapshotGameLetttre = await recordLettreCollection
          .where('uid', isEqualTo: uid)
          .get();
      if (snapshotGameLetttre.docs.isNotEmpty) {
        String record = snapshotGameLetttre.docs.first.get('score').toString();
        lettresRecordPerso = record;
      } else {
        lettresRecordPerso = "0";
      }
    return 1;
  }

Future<int> addNewUserIntoFirestoreLettre() async {
      QuerySnapshot snapshotGameLettre = await recordLettreCollection
          .where('uid', isEqualTo: uid)
          .get();
      if (snapshotGameLettre.docs.isEmpty) {
        await recordLettreCollection.add({
          'uid': uid,
          'game': "MemoireLettres",
          'score': '0',
        });
      }
    await getRecordLettre();
    setState(() {
      lettresRecordPerso;
    });
    return 1;
  }

 Future<int> getRecordNombre() async {
      QuerySnapshot snapshotGameNombre = await recordNombreCollection
          .where('uid', isEqualTo: uid)
          .get();
      if (snapshotGameNombre.docs.isNotEmpty) {
        String record = snapshotGameNombre.docs.first.get('score').toString();
        nombreRecordPerso = record;
      } else {
        nombreRecordPerso = "0";
      }
    return 1;
  }
Future<int> addNewUserIntoFirestoreNombre() async {
      QuerySnapshot snapshotGameNombre = await recordNombreCollection
          .where('uid', isEqualTo: uid)
          .get();
      if (snapshotGameNombre.docs.isEmpty) {
        await recordNombreCollection.add({
          'uid': uid,
          'game': "MemoireNombres",
          'score': '0',
        });
      }
    await getRecordNombre();
    setState(() {
      nombreRecordPerso;
    });
    return 1;
  }


 @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    addNewUserIntoFirestoreLettre();
    addNewUserIntoFirestoreNombre();

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
          image: AssetImage("assets/danse.jpg"),
          alignment: Alignment.bottomCenter,
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 120), // Ajouter un SizedBox avec une hauteur de 20 pixels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F5644),
                    minimumSize: const Size(190, 45),
                    maximumSize: const Size(220, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Nombres',style:TextStyle(color:Colors.white,fontSize: 15)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemoireNombresPage(),
                      ),
                    );
                  },
                ),
                const Icon(Icons.emoji_events, color: Colors.black),
                Text(nombreRecordPerso,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)), 
              ],
            ),
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const  Color(0xFF7F5644),
                    minimumSize: const Size(190, 45),
                    maximumSize: const Size(230, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Lettres',style:TextStyle(color:Colors.white,fontSize: 15)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemoireLettresPage(),
                      ),
                    );
                  },
                ),
                const Icon(Icons.emoji_events, color: Colors.black),
                 Text(lettresRecordPerso,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


}
