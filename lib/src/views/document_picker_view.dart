import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/services/file_picker_service.dart'; // Update this with the actual path
import 'package:studybuddy/src/states/upload_state.dart'; // Update this with the actual path

class DocumentPickerView extends StatefulWidget {
  const DocumentPickerView({super.key});

  @override
  _DocumentPickerViewState createState() => _DocumentPickerViewState();
}

class _DocumentPickerViewState extends State<DocumentPickerView> {
  List<String>? _pickedFileNames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Documents'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickDocuments,
              child: const Text('Select Documents'),
            ),
            ElevatedButton(
              onPressed: _uploadDocuments,
              child: const Text('Upload Documents'),
            ),
            const SizedBox(height: 20),
            _buildFileList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList() {
    if (_pickedFileNames != null) {
      return Column(
        children: _pickedFileNames!.map((name) => Text(name)).toList(),
      );
    } else {
      return const Text('No files selected.');
    }
  }

  Future<void> _pickDocuments() async {
    final filePickerService =
        Provider.of<FilePickerService>(context, listen: false);
    final results = await filePickerService.pickMultipleFiles();

    if (results != null) {
      setState(() {
        _pickedFileNames = results.files.map((file) => file.name).toList();
      });
    }
  }

  Future<void> _uploadDocuments() async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    if (_pickedFileNames != null) {
      // Implement logic to get the directory path of selected files
      String directoryPath = 'path_to_directory'; // Update this
      await uploadState.uploadDocuments(directoryPath);
    }
  }
}
