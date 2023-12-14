import 'package:flutter/foundation.dart';
import 'package:studybuddy/src/services/api_service.dart';

class DocumentController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isUploading = false;

  bool get isUploading => _isUploading;

  void uploadDocument(String directoryPath) async {
    _isUploading = true;
    notifyListeners();

    try {
      await _apiService.uploadDocumentsFromDirectory(directoryPath);
      _isUploading = false;
      // Handle additional logic if needed after successful upload
    } catch (e) {
      // Handle exceptions
      print('Error uploading document: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  // Additional methods as needed for managing documents
}
