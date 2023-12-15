import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/views/additional_questions_view.dart';

class QuestionsView extends StatefulWidget {
  const QuestionsView({super.key});

  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  QAPairsSchema? qaPairsSchema;
  bool isLoading = true;
  int? expandedQuestionIndex;

  @override
  void initState() {
    super.initState();
    _loadQAPairs();
  }

  Future<void> _loadQAPairs() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/qa_pairs.json');
    final String content = await file.readAsString();
    setState(() {
      qaPairsSchema = QAPairsSchema.fromJson(json.decode(content));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Questions')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              qaPairsSchema!.topic,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(qaPairsSchema!.briefSummary),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: qaPairsSchema!.qaPairs.length,
              itemBuilder: (context, index) {
                return _buildQuestionItem(qaPairsSchema!.qaPairs[index], index);
              },
            ),
          ),
        ],
      ),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdditionalQuestionsView(initialQAPair: qaPair),
                  ),
                ),
                child: Text(qaPair.answer),
              ),
            ),
        ],
      ),
    );
  }
}
