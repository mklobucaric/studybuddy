import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/utils/constants.dart';
import 'src/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
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
    return MaterialApp.router(
      title: 'Kid-Friendly Educational App',
      theme: AppTheme.lightTheme, // Define your theme in app_theme.dart
      debugShowCheckedModeBanner: false,
      //     home: HomeView(), // The initial view of your app.
      routerConfig: AppRoutes.router,
    );
  }
}
