import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/routing/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Ensure proper initialization of Flutter bindings.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file.
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with the current platform's default options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase App Check to improve app security.
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider(dotenv.env['RECAPTCHA_SITE_KEY']!),
    // Configure the preferred Android provider for app integrity checks.
    androidProvider: AndroidProvider.debug,
  );

  // Run the Flutter application with the necessary providers.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UploadState()),
        // ... other providers as needed
      ],
      child: const MyApp(),
    ),
  );
}

/// The root widget of the application.
///
/// This widget sets up the application's routing, theme, localization, and other
/// global configurations.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current locale from LocaleProvider.
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp.router(
      title: 'Kid-Friendly Educational App',
      // Apply the light theme defined in app_theme.dart.
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.router, // Define the app routes.
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('de', ''), // German
        Locale('hr', ''),
        Locale('hu', ''),
        // Add other supported locales here
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // Custom localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // For Cupertino widgets
      ],
      locale:
          localeProvider.currentLocale, // Use the locale from LocaleProvider
      // Other properties...
    );
  }
}
