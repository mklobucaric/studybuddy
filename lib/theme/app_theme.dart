import 'package:flutter/material.dart';

/// Defines the global theme settings for the application.
///
/// This class provides ThemeData configurations that can be applied throughout
/// the app to ensure consistent styling, including colors, font styles, button themes,
/// and other UI components.
class AppTheme {
  /// Getter for the light theme of the application.
  ///
  /// This theme defines the appearance for light mode, including colors, typography,
  /// button styles, and other UI elements. It uses a combination of blue and orange
  /// accents, and provides a Poppins font family.
  static ThemeData get lightTheme {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),

      // Define the default font family. Ensure the font is added in pubspec.yaml.
      fontFamily: 'Poppins',

      // Define the default TextTheme for text styling.
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 18.0),
        bodyMedium: TextStyle(fontSize: 16.0),
        labelLarge: TextStyle(fontSize: 18.0, color: Colors.white),
      ),

      // Define the default ButtonTheme for button styling.
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textTheme: ButtonTextTheme.primary,
      ),

      // Define the ElevatedButton style.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ),
      ),

      // Customizations for the AppBar.
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 14, 135, 191), // Softer shade of blue
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          shadows: [
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ],
        ),
      ),
    );
  }

  // Additional themes like a darkTheme can be added here if needed.
}
