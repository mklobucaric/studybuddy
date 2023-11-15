import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<FilePickerResult?> pickFile({FileType fileType = FileType.any}) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: fileType);
      return result;
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  }

  Future<FilePickerResult?> pickMultipleFiles(
      {FileType fileType = FileType.any}) async {
    try {
      FilePickerResult? results = await FilePicker.platform.pickFiles(
        type: fileType,
        allowMultiple: true,
      );
      return results;
    } catch (e) {
      print("Error picking multiple files: $e");
      return null;
    }
  }
}
