import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/user.dart';

class RegistrationView extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
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
                  return 'Please entar a valid email!';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
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
                  return 'Please entar a valid password!';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: const Text('Register'),
            ),
            SizedBox(height: 10),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text("Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    setState(() {
      _errorMessage = '';
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match.');
    }

    try {
      await _authController.register(
          _emailController.text, _passwordController.text);
      if (_authController.currentUser != null) {
        // Create a new user object
        User user = User(
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
          _errorMessage = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
