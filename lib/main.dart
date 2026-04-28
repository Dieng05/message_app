import 'package:flutter/material.dart';
import 'package:message_app/pages/Acceuil.dart';
import 'package:message_app/pages/UserConnection.dart';
import 'package:message_app/pages/UserRegister.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      debugShowCheckedModeBanner: false,
      home: Acceuil(),
      routes: {
        '/acceuil': (context) => Acceuil(),
        '/userconnection': (context) => Userconnection(),
        '/userregister': (context) => Userregister(),
      },
    );
  }
}
