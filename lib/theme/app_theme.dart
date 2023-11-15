import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),

      // Define the default font family.
      fontFamily: 'Montserrat', // Make sure to add the font in pubspec.yaml

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 18.0),
        bodyMedium: TextStyle(fontSize: 16.0),
        labelLarge: TextStyle(fontSize: 18.0, color: Colors.white),
      ),

      // Define the default ButtonTheme. Use this to style buttons.
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textTheme: ButtonTextTheme.primary,
      ),

      // Other customizations like AppBar, FAB
      appBarTheme: const AppBarTheme(
        color: Colors.blueAccent,
        toolbarTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Add more themes (like darkTheme) if needed
}
