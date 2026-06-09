class User {
  final String uid; // Firebase Auth UID
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // Pour sauvegarder dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  // Pour lire depuis Firestore
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
    );
  }
}