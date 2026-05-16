import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/MessageDatabaseService.dart';

class Connectionform extends StatefulWidget {
  const Connectionform({super.key});

  @override
  State<Connectionform> createState() => _ConnectionformState();
}

class _ConnectionformState extends State<Connectionform> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Entrez votre email',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Entrez votre password',
              ),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () async {
            },
            child: Text(
              'Mot de passe Oublié ?',
              style: TextStyle(color: Colors.red[300]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[300],
              foregroundColor: Colors.white,
              minimumSize: Size(320, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async{
              MessageDatabaseService.instance.verifyUser(emailController.text, passwordController.text);
              if (await MessageDatabaseService.instance.verifyUser(emailController.text, passwordController.text)) {
              Navigator.pushNamed(context, '/contact');
              } else {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: Text('Email ou mot de passe incorrect'),
              ),
              );
              }
            },
            child: Text('Se Connecter', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/userregister');
            },
            child: Text('Créer un nouveau Compte'),
          ),
        ],
      ),
    );
  }
}
