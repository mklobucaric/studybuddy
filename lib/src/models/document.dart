class Document {
  final String id;
  final String name;
  final String url;
  final DateTime creationDate;

  Document(
      {required this.id,
      required this.name,
      required this.url,
      required this.creationDate});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      creationDate: DateTime.parse(json['creationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'creationDate': creationDate.toIso8601String(),
    };
  }
}
