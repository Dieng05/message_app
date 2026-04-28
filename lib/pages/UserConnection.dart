import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/pages/ConnectionForm.dart';

class Userconnection extends StatefulWidget {
  const Userconnection({super.key});

  @override
  State<Userconnection> createState() => _UserconnectionState();
}

class _UserconnectionState extends State<Userconnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Column(
            children: [
              SizedBox(height: 100),
              Center(
                child: Text('Connection', style: TextStyle(
                    color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),),
              ),
              Text('Entrez Vos Identifiants'),
              Connectionform()
        ]
    )
    )
    );
  }
}