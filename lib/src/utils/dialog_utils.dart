import 'package:flutter/material.dart';
import 'validators.dart';
import 'package:studybuddy/src/utils/localization.dart';

/// Prompts the user for a password.
///
/// Opens a dialog asking the user to enter a password. It validates the input using
/// [Validators.isValidPassword]. The function uses [AppLocalizations] for localization.
///
/// [context] is the BuildContext of the widget that invokes this function.
///
/// Returns the entered password as a [String] if valid, or `null` if the user cancels the dialog.
Future<String?> promptForPassword(BuildContext context) async {
  String? password;
  var localizations = AppLocalizations.of(context);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter Password'),
        content: TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            password = value;
          },
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !Validators.isValidPassword(value)) {
              return localizations?.translate('valid_password') ??
                  'Please enter a valid password!';
            }
            return null;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(password);
            },
          ),
        ],
      );
    },
  );
}

/// Prompts the user to decide whether to link their account with Google.
///
/// Opens a dialog asking the user if they want to link their account with Google.
///
/// [context] is the BuildContext of the widget that invokes this function.
///
/// Returns `true` if the user agrees to link, or `false` otherwise (including if the dialog is dismissed).
Future<bool> promptUserForGoogleLink(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Link with Google'),
            content:
                const Text('Do you want to link your account with Google?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(
                      false); // Returns false if the user chooses not to link
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Returns true if the user chooses to link
                },
              ),
            ],
          );
        },
      ) ??
      false; // Defaults to false if the dialog is dismissed
}
