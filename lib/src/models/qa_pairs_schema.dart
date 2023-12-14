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

class QAPairsSchema {
  final String topic;
  final String briefSummary;
  final List<QAPair> qaPairs;

  QAPairsSchema(
      {required this.topic, required this.briefSummary, required this.qaPairs});

  factory QAPairsSchema.fromJson(Map<String, dynamic> json) {
    return QAPairsSchema(
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
