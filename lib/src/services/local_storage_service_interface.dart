import 'package:studybuddy/src/models/qa_pairs_schema.dart';

/// An interface defining the methods for local storage services.
///
/// This interface specifies how QA content should be saved and retrieved
/// from local storage.
abstract class LocalStorageServiceInterface {
  /// Saves QA content to local storage.
  ///
  /// [qaContent] is the QAContent object to be saved.
  ///
  /// This method should implement the logic to persist QAContent in a local storage system
  /// like SharedPreferences, a local database, or a file.
  Future<void> saveQAContent(QAContent qaContent);

  /// Loads QA content from local storage.
  ///
  /// Returns the loaded QAContent object if it exists, or `null` if no content is found.
  ///
  /// This method should implement the logic to retrieve QAContent from the local storage system
  /// used by the application, ensuring that null is returned if no content exists.
  Future<QAContent?> loadQAContent();
}
