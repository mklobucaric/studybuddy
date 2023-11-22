import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/user.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:provider/provider.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthenticationController _authController = AuthenticationController();
  String _errorMessage = '';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('register') ?? 'Register'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle localization change
              // You would typically call a function here that sets the locale for your app
              // For example: context.setLocale(Locale(value));
              var localeProvider =
                  Provider.of<LocaleProvider>(context, listen: false);
              localeProvider.setLocale(Locale(value));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'de',
                child: Text('Deutsch'),
              ),
              const PopupMenuItem<String>(
                value: 'hr',
                child: Text('Hrvatski'),
              ),
              const PopupMenuItem<String>(
                value: 'hu',
                child: Text('Magyar'),
              ),
            ],
            icon: const Icon(Icons.language), // Icon for the dropdown button
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText:
                    localizations?.translate('first_name') ?? 'First Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: localizations?.translate('last_name') ?? 'Last Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !Validators.isValidEmail(value)) {
                  return localizations?.translate('valid_email') ??
                      'Please entar a valid email!';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: localizations?.translate('email') ?? 'Email',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !Validators.isValidPassword(value)) {
                  return localizations?.translate('valid_password') ??
                      'Please entar a valid password!';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: localizations?.translate('password') ?? 'Password',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations?.translate('confirm_password') ??
                    'Confirm Password',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text(localizations?.translate('register') ?? 'Register'),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => context.go('/'),
              child: Text(localizations?.translate('have_account') ??
                  "Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    var localizations = AppLocalizations.of(context);
    setState(() {
      _errorMessage = '';
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage =
          localizations?.translate('password_dont_match') ??
              'Passwords do not match.');
      return;
    }

    try {
      String? errorEmail = await _authController.register(
          _emailController.text, _passwordController.text);
      if (_authController.currentUser != null) {
        // Create a new user object
        UserJson user = UserJson(
          id: _authController.currentUser!.uid,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toJson());

        // Navigate to the home screen or another appropriate screen
        if (!mounted) return;
        GoRouter.of(context).go('/home');
      } else {
        setState(() {
          if (errorEmail == "existing_email") {
            _errorMessage = localizations?.translate('existing_email') ??
                'An account already exists for that email.';
          } else {
            _errorMessage = localizations?.translate('registration_failed') ??
                'Registration failed. Please try again.';
            print(errorEmail);
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
