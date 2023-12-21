import 'package:flutter/material.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/services/local_storage_service.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';

class QuestionsView extends StatefulWidget {
  const QuestionsView({super.key});

  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  QAContent? qaContent;
  bool isLoading = true;
  int? expandedQuestionIndex;

  @override
  void initState() {
    super.initState();
    _loadQAPairs();
  }

  Future<void> _loadQAPairs() async {
    LocalStorageServiceInterface localStorageService = getLocalStorageService();
    try {
      var loadedQAContent = await localStorageService.loadQAContent();
      setState(() {
        qaContent = loadedQAContent;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        // Handle error or set an error flag to display an error message
      });
      print('Error loading QA pairs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    if (isLoading) {
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
              Text(localizations?.translate('questionsTitle') ?? 'Questions')
            ],
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
            Text(localizations?.translate('questionsTitle') ?? 'Questions')
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : qaContent == null
              ? Center(
                  child: Text(localizations?.translate('noDataMessage') ??
                      'No QA content available.')) // Show no data message
              : _buildQAContent(), // Show QA content
    );
  }

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(qaContent!.briefSummary),
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
