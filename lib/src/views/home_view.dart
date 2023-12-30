import 'package:flutter/material.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studybuddy/src/models/history.dart';
import 'package:studybuddy/src/widgets/interactive_card.dart';
import 'package:studybuddy/src/services/local_storage_service.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<HistoryItem> _historyItems = [];
  int? expandedHistoryIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistoryItems();
    });
  }

  Future<void> _fetchHistoryItems() async {
    var authController =
        Provider.of<AuthenticationController>(context, listen: false);
    var currentUser = authController.currentUser;
    var currentUserId = currentUser?.uid;
    setState(() => _isLoading = true);
    try {
      var snapshot = await _firestore
          .collection('history')
          .where('user_id', isEqualTo: currentUserId)
          .get();
      print('Number of documents fetched: ${snapshot.size}');
      setState(() {
        _historyItems = snapshot.docs
            .map((doc) => HistoryItem.fromJson(doc.data()))
            .toList();
        print(_historyItems);
      });
    } catch (e, stackTrace) {
      print('Error fetching history items: $e');
      print('Stack Trace: $stackTrace');
      // Optionally, handle different types of exceptions differently
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
    const crossAxisCount = kIsWeb ? 2 : 1;

    // Calculate the aspect ratio for the cards
    const cardAspectRatio = kIsWeb ? 4 / 3 : 2.1; // Example aspect ratio

    return Scaffold(
      appBar: AppBar(
        title: const Text(" "),
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
            icon: const Icon(Icons.language), // Icon for the dropdown button
          ),
        ],
      ),
      drawer: _buildHistoryDrawer(), // Add the history drawer
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // Set crossAxisCount based on platform
            crossAxisCount: crossAxisCount, // Two items per row
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
                    label: 'pick_documents', destination: '/pickDocuments');
              case 2:
                return const InteractiveCard(
                    label: 'questions', destination: '/questionsAnswers');
              case 3:
                return const InteractiveCard(
                    label: 'submit_question', destination: '/customQuestions');
              default:
                return const Placeholder(); // Fallback placeholder
            }
          },
        ),
      ),
    );
  }

  Widget _buildHistoryDrawer() {
    var localizations = AppLocalizations.of(context);
    return Drawer(
      child: Container(
        color: Theme.of(context)
            .scaffoldBackgroundColor, // Use the theme's background color
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Title for the Drawer
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, bottom: 16.0, right: 16.0, left: 16.0),
                    child: Text(
                      localizations?.translate('qaHistory') ?? 'Q&A History',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // List of History Items
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero, // Removes default padding
                      itemCount: _historyItems.length,
                      itemBuilder: (context, index) {
                        return _buildHistoryItem(_historyItems[index], index);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item, int index) {
    var localizations = AppLocalizations.of(context);
    bool isExpanded = index == expandedHistoryIndex;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('${item.date}\n${item.topic}'),
            onTap: () => _onHistoryItemTap(item),
          ),
          GestureDetector(
            onTap: () => setState(() {
              expandedHistoryIndex = isExpanded ? null : index;
            }),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, right: 4.0, left: 14.0),
              child: isExpanded
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(item.briefSummary),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Text(localizations?.translate('briefSummary') ??
                          'Brief Summary'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onHistoryItemTap(HistoryItem item) async {
    // Your existing _onHistoryItemTap implementation...
    // Fetch the corresponding Q&A document
    LocalStorageServiceInterface localStorageService = getLocalStorageService();

    setState(() => _isLoading = true);
    try {
      List<QueryDocumentSnapshot> qaDocs = await getDocumentsByFields(
        item.date,
        item.topic,
        item.userID,
      );
      if (qaDocs.isNotEmpty) {
        var firstDoc = qaDocs.first;
        var firstDocData = firstDoc.data();
        if (firstDocData != null) {
          var qaContent =
              QAContent.fromJson(firstDocData as Map<String, dynamic>);
          // Save the Q&A to a local file
          await localStorageService.saveQAContent(qaContent);
          // Use qaContent as needed
        } else {
          // Handle the case where the document data is null
          // This might mean the document is empty or doesn't exist
        }

        // Check if the widget is still in the widget tree
        if (!mounted) return;

        // Redirect to QuestionsView with the saved file
        GoRouter.of(context).go('/questionsAnswers');
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<QueryDocumentSnapshot>> getDocumentsByFields(
      String date, String topic, String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('questions_answers')
        .where('date', isEqualTo: date)
        .where('topic', isEqualTo: topic)
        .where('user_id', isEqualTo: userID)
        .get();

    return querySnapshot.docs;
  }
}
