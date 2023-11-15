import 'package:flutter/material.dart';
import 'camera_view.dart';
import 'document_picker_view.dart';
import 'questions_view.dart';
import 'ask_question_view.dart';
import 'package:studybuddy/src/widgets/custom_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Buddy'),
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
      child: CustomButton(
        text: text,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => view),
        ),
        color: Colors.blue,
        textColor: Colors.white,
      ),
    );
  }
}
