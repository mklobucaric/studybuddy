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
      fontFamily: 'Poppins', // Make sure to add the font in pubspec.yaml
      //   fontFamily: 'Montserrat', // Make sure to add the font in pubspec.yaml
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
        //buttonColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          //backgroundColor: Colors.blueAccent, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // other properties like textStyle
        ),
      ),

      // Other customizations like AppBar, FAB
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 14, 135, 191), // Softer shade of blue
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white, // White text for better contrast
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins', // Keeping the fun and legible font
          shadows: [
            Shadow(
              // Shadow for a 3D effect
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ],
        ),
      ),
    );
  }

  // Add more themes (like darkTheme) if needed
}
