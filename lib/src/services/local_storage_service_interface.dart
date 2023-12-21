import 'package:studybuddy/src/models/qa_pairs_schema.dart';

abstract class LocalStorageServiceInterface {
  Future<void> saveQAContent(QAContent qaContent);
  Future<QAContent?> loadQAContent();
}
