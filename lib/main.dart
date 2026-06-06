import 'package:flutter/material.dart';
import 'package:message_app/data/initial_data.dart';
import 'package:message_app/pages/Acceuil.dart';
import 'package:message_app/pages/UserConnection.dart';
import 'package:message_app/pages/UserProfil.dart';
import 'package:message_app/pages/UserRegister.dart';
import 'package:message_app/pages/contact.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitialData.seedContacts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Acceuil(),
      routes: {
        '/userconnection': (context) => Userconnection(),
        '/contact': (context) => Contact(),
        '/userregister': (context) => Userregister(),
        '/profil': (context) => Userprofil(),
      },
    );
  }
}
