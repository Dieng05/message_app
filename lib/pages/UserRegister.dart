import 'package:flutter/material.dart';

import '../widgets/Form/RegisterForm.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80),
            Center(
              child: Text(
                'Créer Un Compte',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text('Veuillez remplir le formulaire ci-dessous'),
            Registerform(),
          ],
        ),
      ),
    );
  }
}
