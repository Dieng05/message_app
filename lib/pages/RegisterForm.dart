import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/services/MessageDatabaseService.dart';

import '../models/User.dart';

class Registerform extends StatefulWidget {
  const Registerform({super.key});

  @override
  State<Registerform> createState() => _RegisterformState();
}

class _RegisterformState extends State<Registerform> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: TextField(
                controller: firstNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                  hintText: 'Entrez votre nom',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: TextField(
                controller: lastNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prenom',
                  hintText: 'Entrez votre prenom',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
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
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Entrez votre password',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.white,
                minimumSize: Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                MessageDatabaseService.instance.insertUser(User(firstName: firstNameController.text, lastName: lastNameController.text, email: emailController.text, password: passwordController.text));
                Navigator.pushNamed(context, '/userconnection');
              },
              child: Text('Créer le Compte', style: TextStyle(fontSize: 15)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/userconnection');
              },
              child: Text('J\'ai déja un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
