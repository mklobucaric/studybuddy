import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/views/home_view.dart'; // Update with your actual file paths
import 'package:studybuddy/src/views/login_view.dart';
import 'package:studybuddy/src/views/registration_view.dart';
import 'package:studybuddy/src/views/questions_view.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationView(),
      ),
      GoRoute(
        path: '/questions_answers',
        builder: (context, state) => const QuestionsView(),
      ),
    ],
  );
}
