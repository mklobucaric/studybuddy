class User {
  final String id;
  final String name;
  final String email;
  // Add additional fields as necessary, like profile picture URL, age, etc.

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      // Initialize additional fields here if added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // Convert additional fields to JSON if added
    };
  }

  // Add any additional methods that are relevant for the user,
  // such as methods to update user information, etc.
}
