import 'package:flutter/material.dart';
import 'package:message_app/models/User.dart';
import 'package:message_app/widgets/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/MessageDatabase.dart';

class Userprofil extends StatefulWidget {
  const Userprofil({super.key});

  @override
  State<Userprofil> createState() => _UserprofilState();
}

class _UserprofilState extends State<Userprofil> {
  User? _user;
  bool _isLoading = true;
  bool _isEditing = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController  = TextEditingController();
    _loadUser();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Récupère l'email sauvegardé au moment du login
  Future<String?> _getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('connected_user_email');
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);

    final email = await _getCurrentUserEmail();
    if (email == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/userconnection');
      return;
    }

    final user = await MessageDatabase.instance.getUserByEmail(email);

    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
        if (user != null) {
          _firstNameController.text = user.firstName;
          _lastNameController.text  = user.lastName;
        }
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_user == null) return;

    final updatedUser = User(
      firstName: _firstNameController.text.trim(),
      lastName:  _lastNameController.text.trim(),
      email:     _user!.email,
      password:  _user!.password,
    );

    await MessageDatabase.instance.updateUser(updatedUser);
    await _loadUser();
    setState(() => _isEditing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour ✓'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('connected_user_email');
    if (mounted) Navigator.pushReplacementNamed(context, '/userconnection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          if (!_isLoading && _user != null)
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: () => setState(() => _isEditing = !_isEditing),
            ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text("Utilisateur introuvable"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                  const AssetImage("assets/images/avatar.png"),
                  onBackgroundImageError: (_, __) {},
                  child: Text(
                    '${_user!.firstName.isNotEmpty ? _user!.firstName[0] : '?'}${_user!.lastName.isNotEmpty ? _user!.lastName[0] : ''}'
                        .toUpperCase(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_user!.firstName} ${_user!.lastName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _user!.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(),

            // Champs affichage ou édition
            if (_isEditing) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('Prénom'),
                subtitle: Text(_user!.firstName),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Nom'),
                subtitle: Text(_user!.lastName),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(_user!.email),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // ── Bouton déconnexion ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Se déconnecter',
                    style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}