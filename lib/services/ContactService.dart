import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ContactModel.dart';

class ContactService {
  static final ContactService instance = ContactService._();
  ContactService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _ref(String ownerEmail) =>
      _db.collection('users').doc(ownerEmail).collection('contacts');

  Future<void> saveContact({
    required String ownerEmail,
    required String name,
    required String email,
  }) =>
      _ref(ownerEmail).doc(email).set({'name': name, 'email': email});

  Stream<List<ContactModel>> contactsStream(String ownerEmail) =>
      _ref(ownerEmail).snapshots().map((snap) {
        final list = snap.docs
            .map((doc) => ContactModel(
                  name: doc['name'] as String,
                  email: doc['email'] as String,
                ))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
        return list;
      });
}