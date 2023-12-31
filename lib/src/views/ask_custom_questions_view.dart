import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:provider/provider.dart';

/// A view for users to ask custom questions and view responses.
///
/// This widget provides an interface for users to input custom questions,
/// sends them to the API, and displays the responses.
class AskCustomQuestionsView extends StatefulWidget {
  const AskCustomQuestionsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AskCustomQuestionsViewState createState() => _AskCustomQuestionsViewState();
}

class _AskCustomQuestionsViewState extends State<AskCustomQuestionsView> {
  final _apiService = ApiService(); // Service for API interactions
  final TextEditingController _questionController =
      TextEditingController(); // Controller for the question input field
  List<Map<String, String>> messages =
      []; // List to hold the conversation messages
  bool _isLoading = false; // Flag to indicate loading state

  @override
  void initState() {
    super.initState();
  }

  /// Sends the user's custom question to the backend and updates the conversation.
  ///
  /// [context] is the current BuildContext.
  /// [languageCode] is the current language code for localization.
  Future<void> _sendQuestion(BuildContext context, String languageCode) async {
    final userQuestion = _questionController.text;
    if (userQuestion.isEmpty) return;

    setState(() {
      _isLoading = true;
      messages.add({"role": "user", "content": userQuestion});
    });

    try {
      final assistantAnswer = await _apiService.sendCustomQuestionAndGetAnswer(
          messages, languageCode);
      setState(() {
        messages.add({"role": "assistant", "content": assistantAnswer});
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _questionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    // Building the UI for asking custom questions
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                GoRouter.of(context).go('/home'); // Navigation to home
              },
              child: const Text('Study Buddy'),
            ),
            Text(localizations?.translate('customQuestionsTitle') ??
                'Custom Questions')
          ],
        ),
      ),
      body: Column(
        children: [
          // Displaying the conversation messages
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['content'] ?? ''),
                  subtitle:
                      Text(message['role'] == 'user' ? 'User' : 'Assistant'),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(), // Loading indicator
          // Input field for asking a custom question
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: localizations?.translate('askQuestionLabel') ??
                    'Ask a question',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendQuestion(
                      context, localeProvider.currentLocale.languageCode),
                ),
              ),
              onSubmitted: (_) => _sendQuestion(
                  context, localeProvider.currentLocale.languageCode),
            ),
          ),
        ],
      ),
    );
  }
}
