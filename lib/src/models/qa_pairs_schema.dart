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
  final String date;
  final String topic;
  final String briefSummary;
  final List<QAPair> qaPairs;

  QAContent(
      {required this.date,
      required this.topic,
      required this.briefSummary,
      required this.qaPairs});

  factory QAContent.fromJson(Map<String, dynamic> json) {
    return QAContent(
      date: json['date'],
      topic: json['topic'],
      briefSummary: json['brief_summary'],
      qaPairs: (json['qa_pairs'] as List)
          .map((qaPairJson) => QAPair.fromJson(qaPairJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'brief_summary': briefSummary,
      'qa_pairs': qaPairs.map((qaPair) => qaPair.toJson()).toList(),
    };
  }
}
