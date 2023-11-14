class Question {
  final String id;
  final String text;
  final String
      answer; // Assuming each question has a direct answer. Modify as needed.
  bool isAnswered; // To track if the question has been answered

  Question(
      {required this.id,
      required this.text,
      required this.answer,
      this.isAnswered = false});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      answer: json['answer'] as String,
      isAnswered: json['isAnswered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'answer': answer,
      'isAnswered': isAnswered,
    };
  }

  void markAsAnswered() {
    isAnswered = true;
  }
}
