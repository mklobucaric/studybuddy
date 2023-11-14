class Validators {
  static bool isValidEmail(String email) {
    // Regular expression pattern for validating email
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Password validation logic here (e.g., minimum length)
    return password.length >= 8;
  }

  // Add more validators as needed, such as for phone numbers, names, etc.
}
