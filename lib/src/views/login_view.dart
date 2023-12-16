import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('login') ?? 'Login'),
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: localizations?.translate('email') ?? 'Email',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations?.translate('password') ?? 'Password',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text(localizations?.translate('login') ?? 'Login',
                  style: const TextStyle(fontFamily: 'Poppins')),
            ),
            const SizedBox(height: 10),
            // Google Sign-In Button
            ElevatedButton(
              onPressed: () => _loginWithGoogle(context),
              child: Text(
                  localizations?.translate('login_Google') ??
                      'Log in with Google',
                  style: const TextStyle(fontFamily: 'Poppins')),
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
              child: Text(localizations?.translate("create_account") ??
                  "Don't have an account? Sign up"),
            ),
            // Add additional authentication options here
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    var authController =
        Provider.of<AuthenticationController>(context, listen: false);

    setState(() {
      _errorMessage = '';
    });

    try {
      await authController.login(
          _emailController.text, _passwordController.text);
      if (authController.currentUser != null) {
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

  Future<void> _loginWithGoogle(BuildContext context) async {
    var authController =
        Provider.of<AuthenticationController>(context, listen: false);

    setState(() {
      _errorMessage = '';
    });

    try {
      await authController.signInWithGoogle();
      if (authController.currentUser != null) {
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
