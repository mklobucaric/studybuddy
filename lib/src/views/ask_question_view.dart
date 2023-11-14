import 'package:flutter/material.dart';

class AskQuestionView extends StatefulWidget {
  @override
  _AskQuestionViewState createState() => _AskQuestionViewState();
}

class _AskQuestionViewState extends State<AskQuestionView> {
  final TextEditingController _questionController = TextEditingController();
  String? _answer; // This will hold the answer received from the backend

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask a Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Your Question',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendQuestion,
              child: Text('Submit Question'),
            ),
            SizedBox(height: 20),
            _answer == null
                ? Container()
                : Text(
                    'Answer: $_answer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }

  void _sendQuestion() async {
    String questionText = _questionController.text;

    if (questionText.isEmpty) {
      // You can show an alert dialog or a snackbar to inform the user to enter a question
      return;
    }

    // Implement logic to send the question to the backend and receive an answer
    // For now, we just simulate an answer after a delay
    setState(() {
      _answer = 'Simulated answer for: $questionText';
    });

    // Clear the text field
    _questionController.clear();
  }
}
