import 'package:flutter/foundation.dart';
import 'package:studybuddy/src/models/question.dart';
import 'package:studybuddy/src/services/api_service.dart';

class QuestionController with ChangeNotifier {
  ApiService _apiService = ApiService();
  List<Question> _questions = [];
  bool _isLoading = false;

  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;

  void fetchQuestions(String documentUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await _apiService.fetchQuestions(documentUrl);
      _questions =
          response.map<Question>((json) => Question.fromJson(json)).toList();
      _isLoading = false;
    } catch (e) {
      // Handle exceptions
      _isLoading = false;
      print('Error fetching questions: $e');
    } finally {
      notifyListeners();
    }
  }

  void submitAnswer(int questionId, String answer) {
    // Implement the logic to handle user's answer submission
    // This could include sending the answer to the backend and updating the state
  }

  // Additional methods as needed for handling questions and answers
}
