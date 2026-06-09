import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_app/models/User.dart' as model;
import 'package:message_app/widgets/navigation.dart';
import '../services/ServiceConnection.dart';

class Userprofil extends StatefulWidget {
  const Userprofil({super.key});

  @override
  State<Userprofil> createState() => _UserprofilState();
}

class _UserprofilState extends State<Userprofil> {
  model.User? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving  = false;

  final _service = ServiceConnection();

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

  // Charge le profil depuis Firestore via Firebase Auth
  Future<void> _loadUser() async {
    setState(() => _isLoading = true);

    final fbUser = fb.FirebaseAuth.instance.currentUser;

    // Pas de session → retour à la connexion
    if (fbUser == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/userconnection');
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fbUser.uid)
        .get();

    if (mounted) {
      setState(() {
        _user = doc.exists ? model.User.fromMap(doc.data()!) : null;
        _isLoading = false;
        if (_user != null) {
          _firstNameController.text = _user!.firstName;
          _lastNameController.text  = _user!.lastName;
        }
      });
    }
  }

  // Sauvegarde les modifications dans Firestore
  Future<void> _saveChanges() async {
    if (_user == null) return;

    setState(() => _isSaving = true);

    try {
      final updatedUser = model.User(
        uid:       _user!.uid,
        firstName: _firstNameController.text.trim(),
        lastName:  _lastNameController.text.trim(),
        email:     _user!.email,
      );

      await _service.updateUser(updatedUser);
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Déconnexion Firebase (supprime la session automatiquement)
  Future<void> _logout() async {
    await fb.FirebaseAuth.instance.signOut();
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
            // ── En-tête profil ──────────────────────────
            Row(
              children: [
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red[300],
                  child: Text(
                    '${_user!.firstName.isNotEmpty ? _user!.firstName[0] : '?'}'
                        '${_user!.lastName.isNotEmpty ? _user!.lastName[0] : ''}'
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
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

            // ── Mode édition ────────────────────────────
            if (_isEditing) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveChanges,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: const Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // ── Mode affichage ──────────────────────────
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

            // ── Déconnexion ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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