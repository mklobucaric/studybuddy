import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/views/home_view.dart';
import 'package:studybuddy/src/views/login_view.dart';
import 'package:studybuddy/src/views/registration_view.dart';
import 'package:studybuddy/src/views/questions_view.dart';
import 'package:studybuddy/src/views/additional_questions_view.dart';
import 'package:studybuddy/src/views/ask_custom_questions_view.dart';
import 'package:studybuddy/src/views/camera_view.dart';
import 'package:studybuddy/src/views/document_picker_view.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';

/// Defines the routes for the application using the `GoRouter` package.
///
/// This class encapsulates all the route definitions for the application,
/// mapping each route path to its corresponding view.
class AppRoutes {
  // Static instance of GoRouter with route definitions.
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      // Route for the home page.
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
      // Default route, redirects to the login view.
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginView(),
      ),
      // Route for the registration view.
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationView(),
      ),
      // Route for the questions and answers view.
      GoRoute(
        path: '/questionsAnswers',
        builder: (context, state) => const QuestionsView(),
      ),
      // Route for asking custom questions.
      GoRoute(
        path: '/customQuestions',
        builder: (context, state) => const AskCustomQuestionsView(),
      ),
      // Route for the camera view.
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraView(),
      ),
      // Route for document picker view.
      GoRoute(
        path: '/pickDocuments',
        builder: (context, state) => const DocumentPickerView(),
      ),
      // Route for additional questions, with an initial question-answer pair passed as extra data.
      GoRoute(
        path: '/additionalQuestions',
        builder: (context, state) {
          final initialQAPair = state.extra as QAPair;
          return AdditionalQuestionsView(initialQAPair: initialQAPair);
        },
      ),
    ],
  );
}
