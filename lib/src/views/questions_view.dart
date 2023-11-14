import 'package:flutter/material.dart';
import 'package:your_project_name/src/models/question.dart'; // Update with your actual path

class QuestionsView extends StatefulWidget {
  @override
  _QuestionsViewState createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  List<Question> questions = []; // This should be fetched from your backend

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
      ),
      body: questions.isEmpty
          ? Center(child: Text('No questions available.'))
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionItem(questions[index]);
              },
            ),
    );
  }

  Widget _buildQuestionItem(Question question) {
    return Card(
      child: ListTile(
        title: Text(question.text),
        onTap: () {
          // Implement what happens when a question is tapped.
          // For example, showing the answer or marking it for review.
        },
      ),
    );
  }
}
