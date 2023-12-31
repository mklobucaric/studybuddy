/// Represents a JSON structure for a user.
///
/// This class is designed to encapsulate user-related information such as
/// ID, first name, last name, and email. It provides serialization and
/// deserialization capabilities to and from JSON format.
class UserJson {
  // Properties to store user information.
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  /// Constructor for creating a new UserJson object.
  ///
  /// Requires all user-related properties: [id], [firstName], [lastName], and [email].
  UserJson(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email});

  /// Factory constructor to create a new UserJson from a JSON object.
  ///
  /// Converts a JSON map to a UserJson instance, allowing for easy data
  /// extraction from formats like database records or API responses.
  ///
  /// [json] - A map representing the JSON object from which to create the UserJson.
  factory UserJson.fromJson(Map<String, dynamic> json) {
    return UserJson(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }

  /// Converts a UserJson instance into a JSON object.
  ///
  /// Useful for serializing the UserJson object to data sources like databases or web APIs.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
