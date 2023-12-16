import 'package:flutter/foundation.dart';
import 'package:studybuddy/src/services/api_service.dart';

class UploadState with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isUploading = false;

  bool get isUploading => _isUploading;

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
      print('Error uploading documents: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> uploadDocuments(
      List<String> filePaths, String languageCode) async {
    _isUploading = true;
    notifyListeners();

    try {
      bool success = await _apiService.uploadDocuments(filePaths, languageCode);
      if (success) {
        // Handle successful upload
      } else {
        // Handle upload failure
      }
    } catch (e) {
      print('Error uploading documents: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
