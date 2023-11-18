import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'camera_view.dart';
import 'document_picker_view.dart';
import 'questions_view.dart';
import 'ask_question_view.dart';
import 'package:studybuddy/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';

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

    // Using AppLocalizations to get localized strings
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('title') ??
            'Study Buddy'), // Localized title
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
                        title: Text(localizations?.translate('logout') ??
                            'Logout'), // Localized text
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
              var localeProvider =
                  Provider.of<LocaleProvider>(context, listen: false);
              localeProvider.setLocale(Locale(value));
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
            _buildButton(context, 'take_photo', CameraView()),
            _buildButton(context, 'pick_document', DocumentPickerView()),
            _buildButton(context, 'questions', QuestionsView()),
            _buildButton(context, 'submit_question', AskQuestionView()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget view) {
    var localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: 250.0), // Makes the button stretch
        child: CustomButton(
          text: localizations?.translate(text) ?? 'Default Text',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => view),
          ),
          color: Colors.blue,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
