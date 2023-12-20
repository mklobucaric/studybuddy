import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'camera_view.dart';
import 'document_picker_view.dart';
import 'questions_view.dart';
import 'ask_custom_questions_view.dart';
//import 'package:studybuddy/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studybuddy/src/widgets/interactive_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<HistoryItem> _historyItems = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoryItems();
  }

  Future<void> _fetchHistoryItems() async {
    setState(() => _isLoading = true);
    try {
      var snapshot = await _firestore.collection('history').get();
      setState(() {
        _historyItems = snapshot.docs
            .map((doc) => HistoryItem.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      // Handle errors
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
            title: InkWell(
              onTap: () {
                // Use go_router to navigate to HomeView
                GoRouter.of(context).go('/home');
              },
              child: Text(localizations?.translate('title') ?? 'Study Buddy'),
            ),
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
            ],
          ),
          drawer: _buildHistoryDrawer(), // Add the history drawer
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
                    return const InteractiveCard(
                        label: 'take_photo', destination: '/camera');
                  case 1:
                    return const InteractiveCard(
                        label: 'pick_document', destination: '/pickDocuments');
                  case 2:
                    return const InteractiveCard(
                        label: 'questions', destination: '/questionsAnswers');
                  case 3:
                    return const InteractiveCard(
                        label: 'submit_question',
                        destination: '/customQuestions');
                  default:
                    return const Placeholder(); // Fallback placeholder
                }
              },
            ),
          ),
        ));
  }

  Widget _buildHistoryDrawer() {
    return Drawer(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const DrawerHeader(child: Text('History')),
                ..._historyItems.map((item) => ListTile(
                      title: Text(item.topic),
                      subtitle: Text('${item.briefSummary}\n${item.date}'),
                      onTap: () => _onHistoryItemTap(item),
                    )),
              ],
            ),
    );
  }

  Future<void> _onHistoryItemTap(HistoryItem item) async {
    // Your existing _onHistoryItemTap implementation...
    // Fetch the corresponding Q&A document
    setState(() => _isLoading = true);
    try {
      var qaDoc = await _firestore
          .collection('questionsAnswers')
          .doc(item.qaReference)
          .get();
      if (qaDoc.exists) {
        // Save the Q&A to a local file
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${item.qaReference}.json');
        await file.writeAsString(json.encode(qaDoc.data()));

        // Check if the widget is still in the widget tree
        if (!mounted) return;

        // Redirect to QuestionsView with the saved file
        GoRouter.of(context).go('/questions_view', extra: file.path);
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() => _isLoading = false);
    }
  }
}


  // Widget _buildInteractiveCard(
  //     BuildContext context, String label, Widget destination) {
  //   var localizations = AppLocalizations.of(context); // For localized text

  //   return Padding(
  //     padding: const EdgeInsets.all(
  //         4.0), // Reduced padding for better space utilization
  //     child: InkWell(
  //       onTap: () => Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => destination),
  //       ),
  //       child: Card(
  //         elevation: 5,

  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Expanded(
  //               child: Image.asset('assets/images/${label}_icon.png',
  //                   fit: BoxFit.contain), // Adjust image size within card
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(
  //                 localizations?.translate(label) ?? 'Default Text',
  //                 style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight:
  //                         FontWeight.bold), // Adjust font size if necessary
  //               ),
  //             ),
  //           ],
  //         ),
  //         //        ),
  //       ),
  //     ),
  //   );
  // }

