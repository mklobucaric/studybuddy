class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  // Add additional fields as necessary, like profile picture URL, age, etc.

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      // Initialize additional fields here if added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      // Convert additional fields to JSON if added
    };
  }

  // Add any additional methods that are relevant for the user,
  // such as methods to update user information, etc.
}
