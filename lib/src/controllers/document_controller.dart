import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'dart:io';

class DocumentController with ChangeNotifier {
  ApiService _apiService = ApiService();
  String? _uploadedDocumentUrl;
  bool _isUploading = false;

  String? get uploadedDocumentUrl => _uploadedDocumentUrl;
  bool get isUploading => _isUploading;

  void uploadDocument(File document) async {
    _isUploading = true;
    notifyListeners();

    try {
      _uploadedDocumentUrl = await _apiService.uploadDocument(document.path);
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
