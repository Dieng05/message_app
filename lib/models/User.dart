class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
    );
  }
}