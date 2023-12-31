import 'package:studybuddy/src/utils/platform_check.dart';

class Constants {
  // API Endpoints
  static String apiBaseUrl = getBaseUrl();
  static String uploadDocumentsEndpoint = '$apiBaseUrl/api/upload';
  static String sendQGetAEndpoint = '$apiBaseUrl/api/question';
  static String sendCustomQGetAEndpoint = '$apiBaseUrl/api/custom_question';

  // Local Storage Keys
  static const String authTokenKey = 'auth_token';
//  static const String userPreferencesKey = 'user_preferences';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 4.0;

  // Other Global Constants
//  static const int maxFileSize = 5 * 1024 * 1024; // 5 MB

  // Add more constants as needed
}
