import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart' as model;

class ServiceConnection {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Inscription ───────────────────────────────────────────────
  Future<model.User?> insertUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Créer le compte dans Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2. Sauvegarder le profil dans Firestore
      final user = model.User(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());

      return user;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ─── Connexion ─────────────────────────────────────────────────
  Future<model.User?> verifyUser(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Récupérer le profil depuis Firestore
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return model.User.fromMap(doc.data()!);
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // ─── Déconnexion ───────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ─── Utilisateur courant ───────────────────────────────────────
  Future<model.User?> getCurrentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;

    final doc = await _firestore.collection('users').doc(fbUser.uid).get();
    if (doc.exists) {
      return model.User.fromMap(doc.data()!);
    }
    return null;
  }

  // ─── Récupérer un user par email ───────────────────────────────
  Future<model.User?> getUserByEmail(String email) async {
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (query.docs.isNotEmpty) {
      return model.User.fromMap(query.docs.first.data());
    }
    return null;
  }

  // ─── Mettre à jour le profil ───────────────────────────────────
  Future<void> updateUser(model.User user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toMap());
  }

  // ─── Supprimer un compte ───────────────────────────────────────
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
    await _auth.currentUser?.delete();
  }

  // ─── Réinitialisation mot de passe ─────────────────────────────
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ─── Gestion des erreurs Firebase ──────────────────────────────
  String _handleAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible (6 caractères minimum).';
      case 'user-not-found':
      case 'wrong-password':
        return 'Email ou mot de passe incorrect.';
      default:
        return 'Erreur : ${e.message}';
    }
  }
}