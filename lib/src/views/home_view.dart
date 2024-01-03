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
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

/// A view that acts as the home page of the application.
///
/// This widget displays the user's history, allows language selection, and
/// provides navigation to different functionalities like camera, document picker, etc.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false; // Indicates whether the history is being fetched
  List<HistoryItem> _historyItems = []; // List to store history items
  int? expandedHistoryIndex; // Index of the expanded history item

  @override
  void initState() {
    super.initState();
    // Fetch history items after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistoryItems();
    });
  }

  /// Fetches history items from Firestore associated with the current user.
  ///
  /// Retrieves user-specific history items and updates the state.
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
      setState(() {
        _historyItems = snapshot.docs
            .map((doc) => HistoryItem.fromJson(doc.data()))
            .toList();
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching history items: $e');
        print('Stack Trace: $stackTrace');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var authController = Provider.of<AuthenticationController>(context);

    var localizations = AppLocalizations.of(context);

    // Configure the grid item count and aspect ratio
    int gridItemCount = 4; // Adjust as needed
    const crossAxisCount = kIsWeb ? 2 : 1;
    const cardAspectRatio = kIsWeb ? 4 / 3 : 2.1; // Example aspect ratio

    return Scaffold(
      appBar: AppBar(
        title: const Text(" "),
        actions: <Widget>[
          // AppBar actions and user profile button
          _buildAppBarActions(context, authController, localizations),
        ],
      ),
      drawer: _buildHistoryDrawer(), // Drawer displaying user's history
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: cardAspectRatio,
          ),
          itemCount: gridItemCount,
          itemBuilder: (context, index) {
            return _buildGridItem(index, localizations);
          },
        ),
      ),
    );
  }

  Widget _buildAppBarActions(
      BuildContext context,
      AuthenticationController authController,
      AppLocalizations? localizations) {
    var currentUserJson = authController.currentUserJson;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // User profile button
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title:
                          Text(localizations?.translate('logout') ?? 'Logout'),
                      onTap: () {
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
            foregroundColor:
                Theme.of(context).primaryTextTheme.titleLarge?.color,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            '${currentUserJson?.firstName ?? ""} ${currentUserJson?.lastName ?? ""}',
          ),
        ),
        // Language selection dropdown
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
          icon: const Icon(Icons.language),
        ),
      ],
    );
  }

// Inside the HomeView class

  /// Builds a drawer widget that displays the user's history items.
  ///
  /// This drawer shows a list of history items fetched from the database.
  /// It includes a title and a list of items, each of which can be interacted with.
  ///
  /// Uses [_isLoading] to determine whether to show a loading indicator or the list of history items.
  /// Each item in the list is built using the [_buildHistoryItem] method.
  Widget _buildHistoryDrawer() {
    var localizations = AppLocalizations.of(context);
    // Drawer with user's history items
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localizations?.translate('qaHistory') ?? 'Q&A History',
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
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

  /// Builds a widget for each history item in the history drawer.
  ///
  /// [item] is the HistoryItem object containing data to display.
  /// [index] is the index of the item in the history list.
  ///
  /// Returns a widget displaying the history item's information.
  Widget _buildHistoryItem(HistoryItem item, int index) {
    // The widget displays the history item's date, topic, and other relevant information.
    // It may also provide an expandable view to show more details, like a brief summary.
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

  /// Constructs a widget for each item in the grid layout of the home page.
  ///
  /// [index] determines which type of interactive card to create.
  /// [localizations] is used to access localized strings for labels and tooltips.
  ///
  /// Returns a widget based on the index that represents different features of the app.
  Widget _buildGridItem(int index, AppLocalizations? localizations) {
    // Based on the index, this function returns different interactive cards.
    // For example, a card for taking photos, picking documents, asking questions, etc.
    // Each card can navigate to different views or perform different actions.
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
  }

  /// Handles user interaction with history items.
  ///
  /// [item] is the selected HistoryItem object.
  ///
  /// Performs actions when a user taps on a history item, such as navigating to a detailed view
  /// or fetching additional data related to the item.
  Future<void> _onHistoryItemTap(HistoryItem item) async {
    // Your existing _onHistoryItemTap implementation...
    // Fetch the corresponding Q&A document
    LocalStorageServiceInterface localStorageService = getLocalStorageService();
    // This function may navigate to a detailed view of the history item,
    // showing more in-depth information or allowing further interaction.
    // For example, it could open a page showing detailed Q&A content for the selected history item.
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

  /// Fetches documents from Firestore based on specified fields.
  ///
  /// [date], [topic], and [userID] are used to filter the Firestore documents.
  ///
  /// Returns a list of QueryDocumentSnapshot objects representing the fetched documents.
  ///
  /// This function is used to retrieve specific documents from Firestore, filtering them by
  /// given criteria such as date, topic, and user ID. It's typically used in the context of
  /// fetching detailed information for a particular history item.
  Future<List<QueryDocumentSnapshot>> getDocumentsByFields(
      // The function performs a query on Firestore using the provided criteria.
      // It may be used in conjunction with _onHistoryItemTap to fetch detailed data
      // for a particular history item based on its date, topic, and associated user ID.
      String date,
      String topic,
      String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('questions_answers')
        .where('date', isEqualTo: date)
        .where('topic', isEqualTo: topic)
        .where('user_id', isEqualTo: userID)
        .get();

    return querySnapshot.docs;
  }
}
