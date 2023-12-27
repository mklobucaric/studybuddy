import 'package:flutter/material.dart';
import 'validators.dart';
import 'package:studybuddy/src/utils/localization.dart';

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
                  'Please entar a valid password!';
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

Future<bool> promptUserForGoogleLink(BuildContext context) async {
  return await showDialog(
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
                  Navigator.of(context)
                      .pop(false); // User chooses not to link with Google
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // User chooses to link with Google
                },
              ),
            ],
          );
        },
      ) ??
      false; // In case the dialog is dismissed, default to 'false'
}
