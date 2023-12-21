// local_storage_service_mobile.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';

class LocalStorageService implements LocalStorageServiceInterface {
  @override
  Future<void> saveQAContent(QAContent qaContent) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qa_content.json');
      await file.writeAsString(json.encode(qaContent.toJson()));
    } catch (e) {
      print('Error saving QA content: $e');
      // Handle the error appropriately
    }
  }

  @override
  Future<QAContent?> loadQAContent() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qa_content.json');

      // Check if the file exists before trying to read it
      if (!await file.exists()) {
        print('QA content file not found');
        return null; // Return null or handle it as needed
      }

      final String content = await file.readAsString();
      return QAContent.fromJson(json.decode(content));
    } catch (e) {
      // Handle errors in reading the file or parsing JSON
      print('Error loading QA content: $e');
      return null; // Return null or rethrow the error as needed
    }
  }
}
