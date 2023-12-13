import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'src/utils/constants.dart';
import 'src/routing/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
      // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
      // argument for `webProvider`
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. Debug provider
      // 2. Safety Net provider
      // 3. Play Integrity provider
      androidProvider: AndroidProvider.debug);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        // ... other providers
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp.router(
      title: 'Kid-Friendly Educational App',
      theme: AppTheme.lightTheme, // Define your theme in app_theme.dart
      debugShowCheckedModeBanner: false,
      //     home: HomeView(), // The initial view of your app.
      routerConfig: AppRoutes.router,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('de', ''), // German
        Locale('hr', ''),
        Locale('hu', ''),
        // Add other supported locales here
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // Your custom delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // If using Cupertino widgets
      ],
      locale: localeProvider
          .currentLocale, // Use the current locale from LocaleProvider
      // Other properties...
    );
  }
}
