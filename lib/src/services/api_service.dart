import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class ApiService {
  final String _baseUrl =
      'https://your-backend-api.com'; // Replace with your actual API URL

  // Function to upload documents
  static Future<bool> uploadDocuments(String directoryPath) async {
    // Assuming directoryPath is the path to the directory containing the photos
    final uri = Uri.parse('https://your-api-endpoint/upload');
    var request = http.MultipartRequest('POST', uri);

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
      // Handle the response, parse JSON, etc.
      return true;
    } else {
      // Handle error
      return false;
    }
  }

  // Function to fetch questions based on the uploaded content
  Future<List<dynamic>> fetchQuestions(String documentUrl) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/questions?doc=$documentUrl'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // Function to submit a custom question
  Future<String> submitQuestion(String question) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/submit-question'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'question': question}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['answer'];
    } else {
      throw Exception('Failed to submit question');
    }
  }

  // Additional API methods as needed
}
