import 'package:flutter/material.dart';
import '../../services/ServiceConnection.dart';

class Connectionform extends StatefulWidget {
  const Connectionform({super.key});

  @override
  State<Connectionform> createState() => _ConnectionformState();
}

class _ConnectionformState extends State<Connectionform> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _service = ServiceConnection();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _service.verifyUser(email, password);

      if (user != null && context.mounted) {
        Navigator.pushNamed(context, '/contact');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Entrez votre email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mot de passe',
                hintText: 'Entrez votre mot de passe',
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Entrez votre email d\'abord')),
                );
                return;
              }
              await _service.resetPassword(email);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email de réinitialisation envoyé')),
                );
              }
            },
            child: Text('Mot de passe oublié ?', style: TextStyle(color: Colors.red[300])),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[300],
              foregroundColor: Colors.white,
              minimumSize: const Size(320, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _login,
            child: const Text('Se Connecter', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/userregister'),
            child: const Text('Créer un nouveau Compte'),
          ),
        ],
      ),
    );
  }
}