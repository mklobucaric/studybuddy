import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:studybuddy/src/services/api_service.dart';

/// A state management class for handling document uploads.
///
/// This class uses the `ChangeNotifier` to provide updates on the upload process.
/// It communicates with the ApiService to perform the actual document uploads.
class UploadState with ChangeNotifier {
  // Instance of ApiService to handle API calls.
  final ApiService _apiService = ApiService();

  // Private field to track the upload status.
  bool _isUploading = false;

  // Public getter to expose the upload status.
  bool get isUploading => _isUploading;

  /// Uploads documents from a specified directory to an API endpoint.
  ///
  /// Sets the upload status to true, attempts the upload, then resets the status.
  /// Notifies listeners before and after the upload process.
  ///
  /// [directoryPath] - The path of the directory containing the documents.
  /// [languageCode] - The language code associated with the documents.
  Future<void> uploadDocumentsFromDirectory(
      String directoryPath, String languageCode) async {
    _isUploading = true;
    notifyListeners();

    try {
      bool success = await _apiService.uploadDocumentsFromDirectory(
          directoryPath, languageCode);
      if (success) {
        // Additional logic if needed after successful upload
      } else {
        // Handle upload failure
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading documents: $e');
      }
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Uploads a list of documents to an API endpoint.
  ///
  /// Sets the upload status to true, attempts the upload, then resets the status.
  /// Notifies listeners before and after the upload process.
  ///
  /// [files] - A list of PlatformFile objects representing the documents.
  /// [languageCode] - The language code associated with the documents.
  Future<void> uploadDocuments(
      List<PlatformFile> files, String languageCode) async {
    _isUploading = true;
    notifyListeners();

    try {
      bool success = await _apiService.uploadDocuments(files, languageCode);
      if (success) {
        // Handle successful upload
      } else {
        // Handle upload failure
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading documents: $e');
      }
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
