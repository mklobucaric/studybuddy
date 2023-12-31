import 'package:flutter/material.dart';

/// A custom button widget for a Flutter application.
///
/// This widget creates an elevated button with customizable text, colors, and an optional loading indicator.
class CustomButton extends StatelessWidget {
  /// The text displayed on the button.
  final String text;

  /// The callback function to be called when the button is pressed.
  /// If [isLoading] is true, this callback is disabled.
  final VoidCallback? onPressed;

  /// Indicates whether the button should display a loading indicator.
  final bool isLoading;

  /// The background color of the button.
  /// Defaults to [Colors.blue] if not provided.
  final Color color;

  /// The color of the text and loading indicator on the button.
  /// Defaults to [Colors.white] if not provided.
  final Color textColor;

  /// Creates a CustomButton widget.
  ///
  /// [text] is required and sets the button's label.
  /// [onPressed] is a callback for the button press event.
  /// [isLoading] determines whether a loading indicator is shown instead of text.
  /// [color] sets the button's background color.
  /// [textColor] sets the color of the text and loading indicator.
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.color = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }
}
