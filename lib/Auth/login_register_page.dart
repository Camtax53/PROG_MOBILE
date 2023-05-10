import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_application_1/Auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool obscurePassword = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          _controllerEmail.text, _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          _controllerEmail.text, _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _entryFieldPassWord(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          icon: obscurePassword == true ?   Icon(Icons.visibility_off) :  Icon(Icons.visibility), 
                  ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Humm ? $errorMessage',
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.green[200],
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    minimumSize: const Size(250, 40),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
  ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Se connecter' : 'Inscription'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton( 
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text.rich(
      TextSpan(
        text: isLogin ? 'Vous n\'avez pas de compte?' : 'Déjà un compte? ',
        style:  TextStyle(
          color: Colors.grey[600],
              fontSize: 10.0,
        ),
        children:  [
          TextSpan(
            text: isLogin ? 'Inscrivez-vous ici.':'Connectez-vous ici.',
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 10.0, // spécifie la taille de la police
            ),
          ),
        ],
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //  isLogin = args['isLogin'];
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        title: _title(),
        backgroundColor: Colors.orange[200],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    
                    _entryField('Email', _controllerEmail),
                    _entryFieldPassWord('Password', _controllerPassword),
                    _errorMessage(),
                    const SizedBox(height: 170),
                    _submitButton(),
                    _loginOrRegisterButton(),
                  ],
            
          ),
        ),
      ),
    );
  }
}



// class WelcomePage extends StatefulWidget {
//   const WelcomePage({Key? key}) : super(key: key);
//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9E0C8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF9E0C8),
//         //peut etre mettre un logo au centre de l'app bar si on trouve mais sinon nsm
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               const SizedBox(height: 20),
//               const Text(
//                 "Bienvenue dans notre jeu WiNsports",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 150),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.green[200],
//                   backgroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   minimumSize: const Size(250, 40),
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/login', arguments: {'isLogin': true});
//                 },//ajouter une condition,
//                 child: const Text('Créez un compte'),
                  
//               ),
//               const Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Divider(
//                       color: Colors.black,
//                       thickness: 1,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text(
//                       "OU",
//                       style: TextStyle(fontSize: 10),
//                     ),
//                   ),
//                   Expanded(
//                     child: Divider(
//                       color: Colors.black,
//                       thickness: 1,
//                     ),
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.green[200],
//                   backgroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   minimumSize: const Size(250, 40),
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/login', arguments: {'isLogin': false});
//                 },
//                 child: const Text('Connectez Vous'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
