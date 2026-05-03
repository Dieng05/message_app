import 'package:flutter/material.dart';

class Userconnection extends StatefulWidget {
  const Userconnection({super.key});

  @override
  State<Userconnection> createState() => _UserconnectionState();
}

class _UserconnectionState extends State<Userconnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
              SizedBox(height: 100),
              Center(
                child: Text('Connection', style: TextStyle(
                    color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),),
              ),
              Text('Entrez Vos Identifiants'),
        ]
    )
    );
  }
}