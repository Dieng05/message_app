import 'package:flutter/material.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 500,
        centerTitle: true,
        title: Image(image: AssetImage('assets/images/Accueil.jpeg')),
      ),

      body: Column(
        children: [
          Center(
            child: Text(
              'Message-APP',
              style: TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text('Restez Connecter parTout'),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/userconnection');
                },
                child: Text('Se Connecter'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/userregister');
                },
                child: Text('Créer Un Compte'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
