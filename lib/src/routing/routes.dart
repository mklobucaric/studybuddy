import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/views/home_view.dart'; // Update with your actual file paths
import 'package:studybuddy/src/views/login_view.dart';
import 'package:studybuddy/src/views/registration_view.dart';
import 'package:studybuddy/src/views/questions_view.dart';
import 'package:studybuddy/src/views/additional_questions_view.dart';
import 'package:studybuddy/src/views/ask_custom_questions_view.dart';
import 'package:studybuddy/src/views/camera_view.dart';
import 'package:studybuddy/src/views/document_picker_view.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';

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
        path: '/questionsAnswers',
        builder: (context, state) => const QuestionsView(),
      ),
      GoRoute(
        path: '/customQuestions',
        builder: (context, state) => const AskCustomQuestionsView(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraView(),
      ),
      GoRoute(
        path: '/pickDocuments',
        builder: (context, state) => const DocumentPickerView(),
      ),
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
