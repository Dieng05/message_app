import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_app/firebase_options.dart';
import 'package:message_app/pages/Acceuil.dart';
import 'package:message_app/pages/UserConnection.dart';
import 'package:message_app/pages/UserProfil.dart';
import 'package:message_app/pages/UserRegister.dart';
import 'package:message_app/pages/contact.dart';
import 'package:message_app/pages/message.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Acceuil(),
      routes: {
        '/userconnection': (context) => Userconnection(),
        '/message': (context) => const Message(),
        '/contact': (context) => Contact(),
        '/userregister': (context) => Userregister(),
        '/profil': (context) => Userprofil(),
      },
    );
  }
}
