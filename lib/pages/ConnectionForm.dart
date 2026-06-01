import 'package:flutter/material.dart';
import 'package:message_app/Config/ElementUtiles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ServiceConnection.dart';

class Connectionform extends StatefulWidget {
  const Connectionform({super.key});

  @override
  State<Connectionform> createState() => _ConnectionformState();
}

class _ConnectionformState extends State<Connectionform> {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final _service           = ServiceConnection();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '${email}',
                hintText: 'Entrez votre email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Entrez votre password',
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {},
            child: Text(
              'Mot de passe Oublié ?',
              style: TextStyle(color: Colors.red[300]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[300],
              foregroundColor: Colors.white,
              minimumSize: const Size(320, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final email    = emailController.text.trim();
              final password = passwordController.text.trim();

              final isValid = await _service.verifyUser(email, password);

              if (isValid) {
                // ✅ Sauvegarder l'email du user connecté
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('connected_user_email', email);

                if (context.mounted) {
                  Navigator.pushNamed(context, '/contact');
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email ou mot de passe incorrect'),
                    ),
                  );
                }
              }
            },
            child: const Text('Se Connecter', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/userregister');
            },
            child: const Text('Créer un nouveau Compte'),
          ),
        ],
      ),
    );
  }
}