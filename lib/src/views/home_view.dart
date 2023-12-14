//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'camera_view.dart';
import 'document_picker_view.dart';
import 'questions_view.dart';
import 'ask_question_view.dart';
//import 'package:studybuddy/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/states/upload_state.dart';

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

    // Determine the number of items in the grid
    int gridItemCount = 4; // Adjust as needed

    // Calculate the aspect ratio for the cards
    double cardAspectRatio = 4 / 3; // Example aspect ratio

    return ChangeNotifierProvider(
        create: (context) => UploadState(),
        child: Scaffold(
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
                              authController.logout();
                              context.go('/');
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
                  padding: const EdgeInsets.symmetric(
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
                icon:
                    const Icon(Icons.language), // Icon for the dropdown button
              ),
              // ... other actions if needed
              // You can add more actions here if needed
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                childAspectRatio:
                    cardAspectRatio, // Set the aspect ratio of the card
              ),
              itemCount: gridItemCount,
              itemBuilder: (context, index) {
                // Based on index, you can determine which card to build
                switch (index) {
                  case 0:
                    return _buildInteractiveCard(
                        context, 'take_photo', const CameraView());
                  case 1:
                    return _buildInteractiveCard(
                        context, 'pick_document', const DocumentPickerView());
                  case 2:
                    return _buildInteractiveCard(
                        context, 'questions', const QuestionsView());
                  case 3:
                    return _buildInteractiveCard(
                        context, 'submit_question', const AskQuestionView());
                  default:
                    return const Placeholder(); // Fallback placeholder
                }
              },
            ),
          ),
        ));
  }

  Widget _buildInteractiveCard(
      BuildContext context, String label, Widget destination) {
    var localizations = AppLocalizations.of(context); // For localized text

    // Define card size
//    double cardWidth =
    //       MediaQuery.of(context).size.width / 2 - 16; // Adjust width as needed
    //   double cardHeight = cardWidth * 0.5; // Maintain a good aspect ratio

    return Padding(
      padding: const EdgeInsets.all(
          4.0), // Reduced padding for better space utilization
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
        child: Card(
          elevation: 5,

          //         child: Container(
          //        width: cardWidth,
          //        height: cardHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Image.asset('assets/images/${label}_icon.png',
                    fit: BoxFit.contain), // Adjust image size within card
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  localizations?.translate(label) ?? 'Default Text',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold), // Adjust font size if necessary
                ),
              ),
            ],
          ),
          //        ),
        ),
      ),
    );
  }
}
