import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'camera_view.dart';
import 'document_picker_view.dart';
import 'questions_view.dart';
import 'ask_question_view.dart';
import 'package:studybuddy/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var authController = Provider.of<AuthenticationController>(context);
    var currentUserJson = authController.currentUserJson;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Buddy'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Sign Out'),
                        onTap: () {
                          // Perform sign-out logic
                        },
                      ),
                    ],
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context)
                  .primaryTextTheme
                  .titleLarge
                  ?.color, // Ensures text color matches AppBar
              padding: EdgeInsets.symmetric(
                  horizontal: 16), // Same horizontal padding as InkWell
            ),
            child: Text(
              '${currentUserJson?.firstName ?? ""} ${currentUserJson?.lastName ?? ""}',
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle localization change
              // You would typically call a function here that sets the locale for your app
              // For example: context.setLocale(Locale(value));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'de',
                child: Text('Deutsch'),
              ),
              const PopupMenuItem<String>(
                value: 'hr',
                child: Text('Hrvatski'),
              ),
              const PopupMenuItem<String>(
                value: 'hu',
                child: Text('Magyar'),
              ),
            ],
            icon: const Icon(Icons.language), // Icon for the dropdown button
          ),
          // ... other actions if needed
          // You can add more actions here if needed
        ],
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
