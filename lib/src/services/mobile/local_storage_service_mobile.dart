import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';

/// A service class implementing local storage operations for QA content.
///
/// This class provides functionality to save and load QA content to and from
/// the local file system. It implements the LocalStorageServiceInterface.
class LocalStorageService implements LocalStorageServiceInterface {
  /// Saves QA content to the local file system as a JSON file.
  ///
  /// Serializes the provided [qaContent] to JSON format and writes it to a file
  /// in the application's documents directory.
  ///
  /// [qaContent] - The QAContent object to be saved.
  @override
  Future<void> saveQAContent(QAContent qaContent) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qa_content.json');
      await file.writeAsString(json.encode(qaContent.toJson()));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving QA content: $e');
      }

      // Handle the error appropriately
    }
  }

  /// Loads QA content from the local file system.
  ///
  /// Reads the QA content from a JSON file in the application's documents directory,
  /// deserializes it to a QAContent object, and returns it.
  ///
  /// Returns `null` if the file does not exist or if an error occurs.
  @override
  Future<QAContent?> loadQAContent() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qa_content.json');

      // Check if the file exists before trying to read it
      if (!await file.exists()) {
        if (kDebugMode) {
          print('QA content file not found');
        }

        return null; // Return null or handle it as needed
      }

      final String content = await file.readAsString();
      return QAContent.fromJson(json.decode(content));
    } catch (e) {
      // Handle errors in reading the file or parsing JSON
      if (kDebugMode) {
        print('Error loading QA content: $e');
      }

      return null; // Return null or rethrow the error as needed
    }
  }
}
