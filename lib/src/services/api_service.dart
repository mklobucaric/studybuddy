import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/local_storage_service.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class ApiService {
  final String _baseUrl =
      'https://your-backend-api.com'; // Replace with your actual API URL

  // Function to upload documents
  Future<bool> uploadDocumentsFromDirectory(
      String directoryPath, String languageCode) async {
    // Assuming directoryPath is the path to the directory containing the photos
    final uri = Uri.parse('$_baseUrl/api/upload');
    String? firebaseToken =
        await FirebaseAuth.instance.currentUser?.getIdToken();

    if (firebaseToken == null) {
      // Handle the case when token is null
      // For example: throw an error, or return early
      throw Exception('Firebase token is null');
    }
    var request = http.MultipartRequest('POST', uri);
    // Use the current locale from LocaleProvider
    request.headers.addAll({
      'Accept-Language': languageCode,
      'Authorization': 'Bearer $firebaseToken'
    });

    // Add files to the request
    Directory(directoryPath).listSync().forEach((item) {
      if (item is File) {
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          item.readAsBytesSync(),
          filename: item.path.split("/").last,
        ));
      }
    });

    // Send the request to the server
    var response = await request.send();

    if (response.statusCode == 200) {
      // Get the response body
      final responseString = await response.stream.bytesToString();

      // Parse the response body
      final jsonResponse = json.decode(responseString);

      // Convert JSON to QAContent object
      QAContent qaContent = QAContent.fromJson(jsonResponse);

      // Save the QAContent object locally
      try {
        await LocalStorageService().saveQAPairs(qaContent);
        return true;
      } catch (e) {
        print('Error saving QA pairs: $e');
        return false;
      }
    } else {
      // Handle error
      return false;
    }
  }

  Future<bool> uploadDocuments(
      List<String> filePaths, String languageCode) async {
    final uri = Uri.parse('$_baseUrl/api/upload');
    String? firebaseToken =
        await FirebaseAuth.instance.currentUser?.getIdToken();

    if (firebaseToken == null) {
      // Handle the case when token is null
      // For example: throw an error, or return early
      throw Exception('Firebase token is null');
    }

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept-Language': languageCode,
      'Authorization': 'Bearer $firebaseToken'
    });

    for (var path in filePaths) {
      File file = File(path);
      request.files.add(await http.MultipartFile.fromPath(
        'files',
        file.path,
        filename: file.path.split("/").last,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      // Get the response body
      final responseString = await response.stream.bytesToString();

      // Parse the response body
      final jsonResponse = json.decode(responseString);

      // Convert JSON to QAContent object
      QAContent qaContent = QAContent.fromJson(jsonResponse);

      // Save the QAContent object locally
      try {
        await LocalStorageService().saveQAPairs(qaContent);
        return true;
      } catch (e) {
        print('Error saving QA pairs: $e');
        return false;
      }
    } else {
      // Handle error
      return false;
    }
  }

  Future<String> sendQuestionAndGetAnswer(List<Map<String, String>> messages,
      String languageCode, QAContent qaContent, String question) async {
    final uri = Uri.parse(
        '$_baseUrl/api/question'); // Replace with your actual endpoint

    String? firebaseToken =
        await FirebaseAuth.instance.currentUser?.getIdToken();

    if (firebaseToken == null) {
      // Handle the case when token is null
      // For example: throw an error, or return early
      throw Exception('Firebase token is null');
    }
    try {
      var response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept-Language": languageCode,
          "Authorization": "Bearer $firebaseToken"
        },
        body: json.encode(
          {
            'date': qaContent.date,
            'topic': qaContent.topic,
            'brief_summary': qaContent.briefSummary,
            'question': question,
            'messages': messages
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Assuming the backend returns the new answer as part of the response
        // Adjust the below line according to your actual response structure
        String newAnswer = data['new_answer'];
        return newAnswer;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle the error appropriately
      throw Exception('Error sending question: $e');
    }
  }

  Future<String> sendCustomQuestionAndGetAnswer(
      List<Map<String, String>> messages, String languageCode) async {
    final uri = Uri.parse(
        '$_baseUrl/api/custom_question'); // Replace with your actual endpoint

    String? firebaseToken =
        await FirebaseAuth.instance.currentUser?.getIdToken();

    if (firebaseToken == null) {
      // Handle the case when token is null
      // For example: throw an error, or return early
      throw Exception('Firebase token is null');
    }
    try {
      var response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept-Language": languageCode,
          "Authorization": "Bearer $firebaseToken"
        },
        body: json.encode({'messages': messages}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Assuming the backend returns the new answer as part of the response
        // Adjust the below line according to your actual response structure
        String newAnswer = data['new_answer'];
        return newAnswer;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle the error appropriately
      throw Exception('Error sending question: $e');
    }
  }
}



  // Additional API methods as needed

