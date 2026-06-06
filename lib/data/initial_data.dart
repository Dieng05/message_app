import '../models/ContactModel.dart';
import '../Config/SQLdb.dart';

class InitialData {

  static final Sqldb _sqldb = Sqldb();

  // la liste des Liste des contacts initiaux
  static final List<ContactModel> contacts = [
    ContactModel(name: 'Lena Martin',  phone: '+33 6 12 34 56 78'),
    ContactModel(name: 'Safia Benali', phone: '+33 6 98 76 54 32'),
    ContactModel(name: 'Jean Dupont',  phone: '+33 6 55 44 33 22'),
    ContactModel(name: 'Marie Curie',  phone: '+33 6 11 22 33 44'),
    ContactModel(name: 'Paul Bernard', phone: '+33 6 77 88 99 00'),
    ContactModel(name: 'Alice Morel',  phone: '+33 6 33 44 55 66'),
    ContactModel(name: 'Lucas Petit',  phone: '+33 6 22 11 00 99'),
    ContactModel(name: 'Emma Leroy',   phone: '+33 6 44 55 66 77'),
  ];

  // la Fonction est appelée une seule fois au démarrage de l'app
  static Future<void> seedContacts() async {
    for (final contact in contacts) {
      await _sqldb.insertContact(name: contact.name, phone: contact.phone,);
    }
    print("=== Contacts initiaux insérés ===");
  }
}