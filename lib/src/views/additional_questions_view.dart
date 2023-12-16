import 'package:flutter/material.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:provider/provider.dart';

class AdditionalQuestionsView extends StatefulWidget {
  final QAPair initialQAPair;

  const AdditionalQuestionsView({Key? key, required this.initialQAPair})
      : super(key: key);

  @override
  _AdditionalQuestionsViewState createState() =>
      _AdditionalQuestionsViewState();
}

class _AdditionalQuestionsViewState extends State<AdditionalQuestionsView> {
  final _apiService = ApiService();
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() {
    setState(() {
      messages = [
        {"role": "user", "content": widget.initialQAPair.question},
        {"role": "assistant", "content": widget.initialQAPair.answer},
      ];
    });
  }

  Future<void> _sendQuestion(context, String languageCode) async {
    final userQuestion = _questionController.text;
    if (userQuestion.isEmpty) return;

    setState(() {
      _isLoading = true;
      messages.add({"role": "user", "content": userQuestion});
    });

    try {
      final assistantAnswer =
          await _apiService.sendQuestionAndGetAnswer(messages, languageCode);
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Use go_router to navigate to HomeView
                GoRouter.of(context).go('/home');
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
          if (_isLoading) const LinearProgressIndicator(),
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
