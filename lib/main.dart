import 'package:flutter/material.dart';
import 'package:message_app/pages/Acceuil.dart';
import 'package:message_app/pages/UserConnection.dart';
import 'package:message_app/pages/contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Contact()
    );
  }
}
