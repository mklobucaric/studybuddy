import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class HistoryItem {
  final String ocrTextReference;
  final String briefSummary;
  final String date; // Changed to String to store only the date part
  final String qaReference;
  final String topic;

  HistoryItem({
    required this.ocrTextReference,
    required this.briefSummary,
    required this.date,
    required this.qaReference,
    required this.topic,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    // Convert timestamp to DateTime and then to formatted date string
    DateTime dateTime = (json['date'] as Timestamp).toDate();
    String formattedDate = DateFormat('yyyy-MM-dd')
        .format(dateTime); // Format date as 'YYYY-MM-DD'

    return HistoryItem(
      ocrTextReference: json['OCR_text_reference'],
      briefSummary: json['brief_summary'],
      date: formattedDate,
      qaReference: json['qa_reference'],
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OCR_text_reference': ocrTextReference,
      'brief_summary': briefSummary,
      'date': date,
      'qa_reference': qaReference,
      'topic': topic,
    };
  }
}
