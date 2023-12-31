import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerService {
  /// Picks a single file.
  ///
  /// [fileType] specifies the type of file to pick (defaults to any file type).
  ///
  /// Returns a `FilePickerResult` if successful, or `null` if the operation fails.
  Future<FilePickerResult?> pickFile({FileType fileType = FileType.any}) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: fileType);
      return result; // Return the picked file result
    } catch (e) {
      if (kDebugMode) {
        print("Error picking file: $e");
      }

      return null; // Return null if there's an error
    }
  }

  /// Picks multiple files.
  ///
  /// [fileType] specifies the type of files to pick (defaults to any file type).
  ///
  /// Returns a `FilePickerResult` containing the selected files if successful,
  /// or `null` if the operation fails.
  Future<FilePickerResult?> pickMultipleFiles(
      {FileType fileType = FileType.any}) async {
    try {
      FilePickerResult? results = await FilePicker.platform.pickFiles(
        type: fileType,
        allowMultiple: true,
      );
      return results; // Return the results containing multiple files
    } catch (e) {
      if (kDebugMode) {
        print("Error picking multiple files: $e");
      }

      return null; // Return null if there's an error
    }
  }
}
