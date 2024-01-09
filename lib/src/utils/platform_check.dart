import 'package:flutter/foundation.dart';

String getBaseUrl() {
  if (kIsWeb) {
    // Web-specific code
    //return 'http://127.0.0.1:5000'; // Or your production API URL
    return 'https://studybuddy.solutions';
  } else {
    // Fallback for other platforms
    return 'https://studybuddy.solutions';
    //return 'http://10.0.2.2';
  }
}


// String getBaseUrl() {
//   if (kIsWeb) {
//     // Web-specific code
//     return 'http://localhost:5000'; // Or your production API URL
//   } else if (Platform.isAndroid) {
//     // Android-specific code
//     return 'http://10.0.2.2:5000';
//   } else if (Platform.isIOS) {
//     // iOS-specific code
//     // For iOS emulator, use 'localhost' if testing on the simulator
//     return 'http://localhost:5000';
//   } else {
//     // Fallback for other platforms
//     return 'http://127.0.0.1:5000';
//   }
//}