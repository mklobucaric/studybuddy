// import 'package:cloud_firestore/cloud_firestore.dart';
class HistoryItem {
  final String userID;
  final String briefSummary;
  final String date;
  final String languageCode;
  final String topic;

  HistoryItem({
    required this.userID,
    required this.briefSummary,
    required this.date,
    required this.languageCode,
    required this.topic,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      userID: json['user_id'],
      briefSummary: json['brief_summary'],
      date: json['date'],
      languageCode: json['language_code'],
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userID,
      'brief_summary': briefSummary,
      'date': date,
      'language_code': languageCode,
      'topic': topic,
    };
  }
}
