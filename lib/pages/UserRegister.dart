import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ConnectionForm.dart';
import 'RegisterForm.dart';

class Userregister extends StatefulWidget {
  const Userregister({super.key});

  @override
  State<Userregister> createState() => _UserregisterState();
}

class _UserregisterState extends State<Userregister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 100),
              Center(
                child: Text('Créer Un Compte', style: TextStyle(
                    color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),),
              ),
              Text('Veuillez remplir le formulaire ci-dessous'),
              Registerform()
            ]
        )
    )
    );
  }
}
