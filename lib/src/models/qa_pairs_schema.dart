//import 'package:cloud_firestore/cloud_firestore.dart';

class QAPair {
  final int number;
  final String question;
  final String answer;

  QAPair({required this.number, required this.question, required this.answer});

  factory QAPair.fromJson(Map<String, dynamic> json) {
    return QAPair(
      number: json['number'],
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'question': question,
      'answer': answer,
    };
  }
}

class QAContent {
  final String userID;
  final String date;
  final String topic;
  final String briefSummary;
  final String languageCode;
  final List<QAPair> qaPairs;

  QAContent(
      {required this.userID,
      required this.date,
      required this.topic,
      required this.briefSummary,
      required this.languageCode,
      required this.qaPairs});

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

  // Constructor for creating an instance from Firestore document
  // QAContent.fromFirestore(DocumentSnapshot doc)
  //     : userID = doc['user_id'],
  //       date = doc['date'],
  //       topic = doc['topic'],
  //       briefSummary = doc['brief_summary'],
  //       languageCode = doc['language_code'],
  //       qaPairs =
  //           (doc['qa_pairs'] as List).map((e) => QAPair.fromJson(e)).toList();

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
