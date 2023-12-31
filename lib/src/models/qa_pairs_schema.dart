/// Represents a single Question-Answer pair.
///
/// This class is designed to encapsulate a question and its corresponding answer,
/// along with an identifying number for easy referencing.
class QAPair {
  final int number;
  final String question;
  final String answer;

  /// Constructor for creating a new QAPair.
  ///
  /// Requires a unique identifier [number], a [question], and an [answer].
  QAPair({required this.number, required this.question, required this.answer});

  /// Factory constructor to create a new QAPair from a JSON object.
  ///
  /// Useful for deserializing data from formats such as database records or API responses.
  ///
  /// [json] - A map representing the JSON object from which to create the QAPair.
  factory QAPair.fromJson(Map<String, dynamic> json) {
    return QAPair(
      number: json['number'],
      question: json['question'],
      answer: json['answer'],
    );
  }

  /// Converts a QAPair instance into a JSON object.
  ///
  /// Useful for serializing data to formats such as database records or API requests.
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'question': question,
      'answer': answer,
    };
  }
}

/// Represents the content of a QA (Question-Answer) session.
///
/// This class encapsulates the details of a QA session, including user information,
/// session date, topic, a brief summary, language code, and a list of QAPair objects.
class QAContent {
  final String userID;
  final String date;
  final String topic;
  final String briefSummary;
  final String languageCode;
  final List<QAPair> qaPairs;

  /// Constructor for creating a new QAContent.
  ///
  /// Requires user identifier [userID], session [date], [topic], a [briefSummary],
  /// [languageCode], and a list of [qaPairs].
  QAContent(
      {required this.userID,
      required this.date,
      required this.topic,
      required this.briefSummary,
      required this.languageCode,
      required this.qaPairs});

  /// Factory constructor to create a new QAContent from a JSON object.
  ///
  /// Useful for deserializing data from formats such as database records or API responses.
  ///
  /// [json] - A map representing the JSON object from which to create the QAContent.
  factory QAContent.fromJson(Map<String, dynamic> json) {
    return QAContent(
      userID: json['user_id'],
      date: json['date'],
      topic: json['topic'],
      briefSummary: json['brief_summary'],
      languageCode: json['language_code'],
      qaPairs: (json['qa_pairs'] as List)
          .map((qaPairJson) => QAPair.fromJson(qaPairJson))
          .toList(),
    );
  }

  /// Converts a QAContent instance into a JSON object.
  ///
  /// Useful for serializing data to formats such as database records or API requests.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userID,
      'date': date,
      'topic': topic,
      'brief_summary': briefSummary,
      'language_code': languageCode,
      'qa_pairs': qaPairs.map((qaPair) => qaPair.toJson()).toList(),
    };
  }
}
