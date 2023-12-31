import 'package:flutter/material.dart';

/// A custom text field widget for Flutter applications.
///
/// This widget creates a text form field with customizable features such as label, icons,
/// keyboard type, and validation logic.
class CustomTextField extends StatelessWidget {
  /// The label text displayed above the text field.
  final String labelText;

  /// The controller for managing the text being edited.
  final TextEditingController controller;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text].
  final TextInputType keyboardType;

  /// The validation logic used to validate the entered text.
  /// Returns an error string to display if the input is invalid, or null otherwise.
  final String? Function(String?)? validator;

  /// Whether to obscure the text being edited (for example, for passwords).
  final bool obscureText;

  /// The icon displayed at the beginning of the text field.
  final IconData? prefixIcon;

  /// The icon displayed at the end of the text field.
  final IconData? suffixIcon;

  /// The callback function to be called when the suffix icon is pressed.
  final VoidCallback? onSuffixIconPress;

  /// Creates a CustomTextField widget.
  ///
  /// [labelText] is required and sets the label for the text field.
  /// [controller] is required to control the text being edited.
  /// [keyboardType] sets the type of keyboard layout for the text field.
  /// [validator] provides a function for validating the text field's input.
  /// [obscureText] determines whether the text should be obscured.
  /// [prefixIcon] is an optional icon displayed at the start of the text field.
  /// [suffixIcon] is an optional icon displayed at the end of the text field.
  /// [onSuffixIconPress] is a callback for when the suffix icon is tapped.
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconPress,
              )
            : null,
      ),
    );
  }
}
