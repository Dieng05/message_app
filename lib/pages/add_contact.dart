import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/ContactService.dart';
import '../services/ServiceConnection.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _service = ServiceConnection();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final currentEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    if (email == currentEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous ne pouvez pas vous ajouter vous-même')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _service.getUserByEmail(email);

      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aucun compte trouvé avec cet email'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      await ContactService.instance.saveContact(
        ownerEmail: currentEmail,
        name: name,
        email: email,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un contact')),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom',
                    hintText: 'Entrez le nom du contact',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: "Email du contact sur l'application",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _save,
                      child: const Text('Ajouter le contact', style: TextStyle(fontSize: 15)),
                    ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(300, 50),
                  side: const BorderSide(color: Colors.grey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}