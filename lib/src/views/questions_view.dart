import 'package:flutter/material.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/services/local_storage_service.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';

/// A widget for displaying Q&A content in a Flutter application.
///
/// Presents a screen showing a list of questions and their answers, fetched from local storage.
/// It supports expansion of individual questions to view their answers.
class QuestionsView extends StatefulWidget {
  /// Creates a QuestionsView widget.
  ///
  /// Initializes a stateful widget for displaying Q&A pairs.
  /// [key] is an optional parameter for widget key initialization.
  const QuestionsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  // Variable to hold Q&A content.
  QAContent? qaContent;
  // Loading state indicator.
  bool isLoading = true;
  // Index of the currently expanded question.
  int? expandedQuestionIndex;

  @override
  void initState() {
    super.initState();
    _loadQAPairs();
  }

  /// Fetches Q&A pairs from local storage and updates the state.
  ///
  /// Retrieves the QAContent object and updates the widget's state to display the content.
  /// Sets [isLoading] to false once the data is fetched or in case of an error.
  Future<void> _loadQAPairs() async {
    LocalStorageServiceInterface localStorageService = getLocalStorageService();
    try {
      var loadedQAContent = await localStorageService.loadQAContent();
      setState(() {
        qaContent = loadedQAContent;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // Error handling logic here...
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    if (isLoading) {
      return _buildLoadingScreen(localizations);
    }

    return Scaffold(
      appBar: _buildAppBar(context, localizations),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : qaContent == null
              ? Center(
                  child: Text(localizations?.translate('noDataMessage') ??
                      'No QA content available.'))
              : _buildQAContent(),
    );
  }

  /// Constructs the app bar with navigation and title.
  ///
  /// [context] to access navigation.
  /// [localizations] to fetch localized strings.
  AppBar _buildAppBar(BuildContext context, AppLocalizations? localizations) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).go('/home'),
            child: const Text('Study Buddy'),
          ),
          Text(localizations?.translate('questionsTitle') ?? 'Questions'),
        ],
      ),
    );
  }

  /// Builds a loading screen with a progress indicator.
  ///
  /// [localizations] to fetch localized strings.
  Scaffold _buildLoadingScreen(AppLocalizations? localizations) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => GoRouter.of(context).go('/home'),
              child: const Text('Study Buddy'),
            ),
            Text(localizations?.translate('questionsTitle') ?? 'Q&A'),
          ],
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  /// Builds the main content of Q&A pairs.
  ///
  /// Renders the [date] and [topic] of the Q&A session along with a list of Q&A pairs.
  Widget _buildQAContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            qaContent!.date,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            qaContent!.topic,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: qaContent!.qaPairs.length,
            itemBuilder: (context, index) {
              return _buildQuestionItem(qaContent!.qaPairs[index], index);
            },
          ),
        ),
      ],
    );
  }

  /// Constructs a widget for each Q&A pair.
  ///
  /// [qaPair] is the QAPair object containing the question and answer.
  /// [index] is the position of the Q&A pair in the list.
  ///
  /// Returns a Card widget displaying the question and, if expanded, the answer.
  Widget _buildQuestionItem(QAPair qaPair, int index) {
    bool isExpanded = index == expandedQuestionIndex;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('${qaPair.number}. ${qaPair.question}'),
            onTap: () => setState(() {
              expandedQuestionIndex = isExpanded ? null : index;
            }),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () =>
                    context.push('/additionalQuestions', extra: qaPair),
                child: Text(qaPair.answer),
              ),
            ),
        ],
      ),
    );
  }
}
