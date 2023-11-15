import 'package:flutter/material.dart';
import 'camera_view.dart';
import 'document_picker_view.dart';
import 'questions_view.dart';
import 'ask_question_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kid-Friendly Educational App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(context, 'Take Photos', CameraView()),
            _buildButton(context, 'Pick Document', DocumentPickerView()),
            _buildButton(context, 'View Questions', QuestionsView()),
            _buildButton(context, 'Ask a Question', AskQuestionView()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget view) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => view),
        ),
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Use vibrant colors suitable for kids
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
      ),
    );
  }
}
