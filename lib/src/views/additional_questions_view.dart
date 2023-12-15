import 'package:flutter/material.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/api_service.dart';

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

  Future<void> _sendQuestion() async {
    final userQuestion = _questionController.text;
    if (userQuestion.isEmpty) return;

    setState(() {
      _isLoading = true;
      messages.add({"role": "user", "content": userQuestion});
    });

    try {
      final assistantAnswer =
          await _apiService.sendQuestionAndGetAnswer(messages);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Additional Questions')),
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
                labelText: 'Ask a question',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendQuestion,
                ),
              ),
              onSubmitted: (_) => _sendQuestion(),
            ),
          ),
        ],
      ),
    );
  }
}
