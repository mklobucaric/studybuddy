import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:provider/provider.dart';

/// A widget for managing user login in a Flutter application.
///
/// Displays a login screen with fields for email and password input, options for language
/// selection, and buttons for standard login and Google Sign-In. It also shows error messages
/// in case of login failures.
class LoginView extends StatefulWidget {
  /// Creates a LoginView widget.
  ///
  /// Initializes a stateful widget for user login.
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Text controllers for managing input in the email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // String to display error messages, particularly for login issues.
  String _errorMessage = '';

  @override
  void dispose() {
    // Cleans up the text controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accesses localized strings based on the current application context.
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('login') ?? 'Login'),
        actions: <Widget>[
          _buildLanguageSelectionDropdown(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildLoginForm(context, localizations),
      ),
    );
  }

  /// Creates a dropdown menu for language selection.
  ///
  /// Allows users to switch the app's language dynamically, affecting the displayed text.
  /// Populates the dropdown with available language options.
  Widget _buildLanguageSelectionDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        Provider.of<LocaleProvider>(context, listen: false)
            .setLocale(Locale(value));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(value: 'en', child: Text('English')),
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
      icon: const Icon(Icons.language),
    );
  }

  /// Constructs the login form with input fields and action buttons.
  ///
  /// [localizations] provides localized strings for form elements.
  /// The form includes [email] and [password] fields, a [login] button,
  /// and an option for [Google Sign-In]. It also displays any [error messages].
  Widget _buildLoginForm(
      BuildContext context, AppLocalizations? localizations) {
    return Column(
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
              localizations?.translate('login_Google') ?? 'Log in with Google',
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
      ],
    );
  }

  /// Initiates the login process using the provided email and password.
  ///
  /// Authenticates the user with their [email] and [password]. On successful authentication,
  /// navigates to the main screen. On failure, updates the UI with an appropriate [error message].
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

  /// Handles the Google Sign-In process for user authentication.
  ///
  /// Initiates a Google Sign-In flow and handles user authentication. Upon successful sign-in,
  /// redirects to the main screen. In case of failure, updates the UI with an [error message].
  Future<void> _loginWithGoogle(BuildContext context) async {
    var authController =
        Provider.of<AuthenticationController>(context, listen: false);

    setState(() {
      _errorMessage = '';
    });

    try {
      await authController.signInWithGoogle(context);
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
