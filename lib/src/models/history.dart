/// Represents an individual history item in the application.
///
/// This class is designed to store and manage data related to a user's history item,
/// including details like a brief summary, date, language code, and topic.
class HistoryItem {
  // Properties to store various attributes of a history item.
  final String userID;
  final String briefSummary;
  final String date;
  final String languageCode;
  final String topic;

  /// Constructor for creating a new HistoryItem.
  ///
  /// Requires all properties to be provided.
  HistoryItem({
    required this.userID,
    required this.briefSummary,
    required this.date,
    required this.languageCode,
    required this.topic,
  });

  /// Factory constructor to create a new HistoryItem from a JSON object.
  ///
  /// Useful for serialization from data sources like databases or web APIs.
  ///
  /// [json] - A map representing the JSON object from which to create the HistoryItem.
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      userID: json['user_id'],
      briefSummary: json['brief_summary'],
      date: json['date'],
      languageCode: json['language_code'],
      topic: json['topic'],
    );
  }

  /// Converts a HistoryItem instance into a JSON object.
  ///
  /// Useful for serialization to data sources like databases or web APIs.
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
