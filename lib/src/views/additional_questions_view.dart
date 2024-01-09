import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/services/local_storage_service.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';

/// A view for displaying and handling additional questions based on initial Q&A pair.
///
/// This widget provides an interface for users to ask follow-up questions and view responses.
/// [initialQAPair] contains the initial question and answer pair to be displayed.
class AdditionalQuestionsView extends StatefulWidget {
  final QAPair initialQAPair;

  const AdditionalQuestionsView({super.key, required this.initialQAPair});

  @override
  // ignore: library_private_types_in_public_api
  _AdditionalQuestionsViewState createState() =>
      _AdditionalQuestionsViewState();
}

class _AdditionalQuestionsViewState extends State<AdditionalQuestionsView> {
  final _apiService = ApiService(); // Service for API interactions
  final TextEditingController _questionController =
      TextEditingController(); // Controller for the question input field
  List<Map<String, String>> messages =
      []; // List to hold the conversation messages
  QAContent? qaContent; // Stores the QAContent object
  bool _isLoading = false; // Flag to indicate loading state

  @override
  void initState() {
    super.initState();
    _initializeMessages(); // Initialize conversation messages
    _loadQAPairs(); // Load QA pairs from local storage
  }

  /// Initializes the messages list with the initial Q&A pair.
  void _initializeMessages() {
    setState(() {
      messages = [
        {"role": "user", "content": widget.initialQAPair.question},
        {"role": "assistant", "content": widget.initialQAPair.answer}
      ];
    });
  }

  /// Loads QA pairs from local storage.
  ///
  /// Retrieves and sets the QAContent object from local storage.
  /// Sets the loading state accordingly.
  Future<void> _loadQAPairs() async {
    LocalStorageServiceInterface localStorageService = getLocalStorageService();
    try {
      var loadedQAContent = await localStorageService.loadQAContent();
      setState(() {
        qaContent = loadedQAContent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Handle error or set an error flag to display an error message
      });
      if (kDebugMode) {
        print('Error loading QA pairs: $e');
      }
    }
  }

  /// Sends the user's question to the backend and updates the conversation.
  ///
  /// [context] is the current BuildContext.
  /// [languageCode] is the current language code for localization.
  Future<void> _sendQuestion(BuildContext context, String languageCode) async {
    final userQuestion = _questionController.text;
    if (userQuestion.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, String>> backendMessages =
          await _apiService.sendQuestionAndGetAnswer(
              messages, languageCode, qaContent!, userQuestion);
      final assistantResponse = backendMessages.last;
      String assistantContent = assistantResponse['content']!;
      setState(() {
        messages.add({"role": "user", "content": userQuestion});
        messages.add({"role": "assistant", "content": assistantContent});
        //messages = backendMessages;
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

    // Building the UI for the additional questions view
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
            Text(localizations?.translate('additionalquestionsTitle') ??
                'Additional Questions')
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
          // Input field for asking a follow-up question
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText:
                    localizations?.translate('askFollowUpQuestionLabel') ??
                        'Ask a follow up question',
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
