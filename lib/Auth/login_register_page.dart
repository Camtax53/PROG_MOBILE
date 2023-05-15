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
          icon: obscurePassword == true
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
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
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF09B198),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.0,
          ),
          children: [
            TextSpan(
              text: isLogin ? ' Inscrivez-vous ici.' : ' Connectez-vous ici.',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                // spécifie la taille de la police
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
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/runningbg.png"),
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60),
                _entryField('Email', _controllerEmail),
                _entryFieldPassWord('Password', _controllerPassword),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),
                const SizedBox(height: 2000),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
