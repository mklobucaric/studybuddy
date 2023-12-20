import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:studybuddy/src/models/qa_pairs_schema.dart';

class LocalStorageService {
  Future<void> saveQAPairs(QAContent qaPairs) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qa_pairs.json');
      await file.writeAsString(json.encode(qaPairs.toJson()));
    } catch (e) {
      // Handle the error, e.g., log it or show an error message
      print('Error saving QA pairs: $e');
      throw Exception('Error saving data');
    }
  }

  Future<QAContent?> loadQAPairs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qa_pairs.json');

      // Check if the file exists before trying to read it
      if (!await file.exists()) {
        print('QA pairs file not found');
        return null; // Return null or handle it as needed
      }

      final String content = await file.readAsString();
      return QAContent.fromJson(json.decode(content));
    } catch (e) {
      // Handle errors in reading the file or parsing JSON
      print('Error loading QA pairs: $e');
      return null; // Return null or rethrow the error as needed
    }
  }
}
