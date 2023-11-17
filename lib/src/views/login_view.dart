import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authController = AuthenticationController();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            // Google Sign-In Button
            ElevatedButton(
              onPressed: () => _loginWithGoogle(context),
              child: const Text('Sign in with Google'),
              // You can add more styling as needed
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text("Don't have an account? Sign up"),
            ),
            // Add additional authentication options here
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    setState(() {
      _errorMessage = '';
    });

    try {
      await _authController.login(
          _emailController.text, _passwordController.text);
      if (_authController.currentUser != null) {
        // Navigate to the home screen or another appropriate screen
        if (!mounted) return;
        GoRouter.of(context).go('/home');
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _loginWithGoogle(BuildContext context) async {
    setState(() {
      _errorMessage = '';
    });

    try {
      await _authController.signInWithGoogle();
      if (_authController.currentUser != null) {
        // Navigate to the home screen or another appropriate screen
        if (!mounted) return;
        GoRouter.of(context).go('/home');
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
