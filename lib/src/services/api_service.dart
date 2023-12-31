import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:studybuddy/src/models/qa_pairs_schema.dart';
import 'package:studybuddy/src/services/local_storage_service.dart';
import 'package:studybuddy/src/services/local_storage_service_interface.dart';
import 'package:studybuddy/src/controllers/authentication_controller.dart';
import 'package:studybuddy/src/utils/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class ApiService {
  // Service for interacting with local storage
  LocalStorageServiceInterface localStorageService = getLocalStorageService();
  // Controller for handling authentication
  final AuthenticationController _authController = AuthenticationController();

  /// Uploads documents from a specified directory to a server.
  ///
  /// [directoryPath] specifies the local directory path containing the documents.
  /// [languageCode] is used for the 'Accept-Language' header in the request.
  ///
  /// Returns `true` if the upload is successful, `false` otherwise.
  /// Throws an Exception if the Firebase token is null.
  Future<bool> uploadDocumentsFromDirectory(
      String directoryPath, String languageCode) async {
    final uri = Uri.parse(Constants.uploadDocumentsEndpoint);
    String? firebaseToken = await _authController.getValidTokenForApiCall();

    if (firebaseToken == null) {
      throw Exception('Firebase token is null');
    }

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept-Language': languageCode,
      'Authorization': 'Bearer $firebaseToken'
    });

    // Adding files from the directory to the request
    Directory(directoryPath).listSync().forEach((item) {
      if (item is File) {
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          item.readAsBytesSync(),
          filename: item.path.split("/").last,
        ));
      }
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseString);
      QAContent qaContent = QAContent.fromJson(jsonResponse);

      try {
        await localStorageService.saveQAContent(qaContent);
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('Error saving QA pairs: $e');
        }
        return false;
      }
    } else {
      return false; // Error handling for unsuccessful upload
    }
  }

  /// Uploads a list of documents represented by `PlatformFile` objects.
  ///
  /// [files] is a list of `PlatformFile` objects to be uploaded.
  /// [languageCode] is used for the 'Accept-Language' header in the request.
  ///
  /// Returns `true` if the upload is successful, `false` otherwise.
  /// Handles various network and file-related exceptions.
  Future<bool> uploadDocuments(
      List<PlatformFile> files, String languageCode) async {
    final uri = Uri.parse(Constants.uploadDocumentsEndpoint);
    String? firebaseToken = await _authController.getValidTokenForApiCall();

    if (firebaseToken == null) {
      throw Exception('Firebase token is null');
    }

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept-Language': languageCode,
      'Authorization': 'Bearer $firebaseToken'
    });

    // Adding files to the request
    for (var file in files) {
      if (file.bytes == null) {
        final fileBytes = await File(file.path!).readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          fileBytes,
          filename: file.name,
        ));
      } else {
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          file.bytes!,
          filename: file.name,
        ));
      }
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseString);
        QAContent qaContent = QAContent.fromJson(jsonResponse);

        try {
          await localStorageService.saveQAContent(qaContent);
          return true;
        } catch (e) {
          if (kDebugMode) {
            print('Error saving QA pairs: $e');
          }

          return false;
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }

        final responseString = await response.stream.bytesToString();
        if (kDebugMode) {
          print('Response body: $responseString');
        }

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling for various exceptions');
      }

      return false;
    }
  }

  /// Sends a question along with additional information and retrieves the answer.
  ///
  /// [messages] is a list of Map<String, String> representing previous interactions.
  /// [languageCode] is used for the 'Accept-Language' header in the request.
  /// [qaContent] contains the date, topic, and brief summary of the QA context.
  /// [question] is the user's query.
  ///
  /// Returns a list of Map<String, String> with the answer(s) from the backend.
  /// Throws an Exception if the Firebase token is null or if the request fails.
  Future<List<Map<String, String>>> sendQuestionAndGetAnswer(
      List<Map<String, String>> messages,
      String languageCode,
      QAContent qaContent,
      String question) async {
    final uri = Uri.parse(Constants.sendQGetAEndpoint);

    String? firebaseToken = await _authController.getValidTokenForApiCall();

    if (firebaseToken == null) {
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
        List<dynamic> backendMessages = json.decode(response.body);
        return backendMessages
            .map((item) => Map<String, String>.from(item as Map))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error sending question: $e');
    }
  }

  /// Sends custom question data and retrieves a corresponding answer.
  ///
  /// [messages] is a list of Map<String, String> representing user interactions.
  /// [languageCode] is used for the 'Accept-Language' header in the request.
  ///
  /// Returns a String containing the answer or response from the backend.
  /// Throws an Exception if the Firebase token is null or if the request fails.
  Future<String> sendCustomQuestionAndGetAnswer(
      List<Map<String, String>> messages, String languageCode) async {
    final uri = Uri.parse(Constants.sendCustomQGetAEndpoint);

    String? firebaseToken = await _authController.getValidTokenForApiCall();

    if (firebaseToken == null) {
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
        String newAnswer =
            data['new_answer']; // Assuming this key holds the answer
        return newAnswer;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error sending question: $e');
    }
  }

  // The methods `sendQuestionAndGetAnswer` and `sendCustomQuestionAndGetAnswer`
  // can be similarly annotated with comments and docstrings.
  // Additional API methods and comments can be added here.
}
