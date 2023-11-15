import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {
  final String _baseUrl =
      'https://your-backend-api.com'; // Replace with your actual API URL

  // Function to upload documents
  Future<String> uploadDocument(String filePath) async {
    // Implement the logic to upload a document
    // Return the response from the backend (e.g., URL of the uploaded document)
    return "test"; // only for test purpose
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
