import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/services/file_picker_service.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:go_router/go_router.dart';

class DocumentPickerView extends StatefulWidget {
  const DocumentPickerView({super.key});

  @override
  _DocumentPickerViewState createState() => _DocumentPickerViewState();
}

class _DocumentPickerViewState extends State<DocumentPickerView> {
  List<String>? _pickedFilePaths; // Store file paths instead of just names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Documents'),
      ),
      body: Selector<UploadState, bool>(
        selector: (_, uploadState) => uploadState.isUploading,
        builder: (context, isUploading, _) {
          return Stack(
            children: [
              Center(
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
              if (isUploading) const LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFileList() {
    if (_pickedFilePaths != null) {
      return Column(
        children: _pickedFilePaths!
            .map((path) => Text(path.split('/').last))
            .toList(),
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
        _pickedFilePaths =
            results.files.map((file) => file.path).cast<String>().toList();
      });
    }
  }

  Future<void> _uploadDocuments() async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    if (_pickedFilePaths != null) {
      await uploadState.uploadDocuments(_pickedFilePaths!);

      // If the widget is still mounted and upload is complete, navigate to another view
      if (!mounted) return;
      if (!uploadState.isUploading) {
        GoRouter.of(context)
            .go('/next_route'); // Replace '/next_route' with your desired route
      }
    }
  }
}
