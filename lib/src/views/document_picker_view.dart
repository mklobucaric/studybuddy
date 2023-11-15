import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentPickerView extends StatefulWidget {
  const DocumentPickerView({super.key});

  @override
  _DocumentPickerViewState createState() => _DocumentPickerViewState();
}

class _DocumentPickerViewState extends State<DocumentPickerView> {
  String? _pickedFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Document'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickDocument,
              child: const Text('Select Document'),
            ),
            const SizedBox(height: 20),
            _pickedFileName != null
                ? Text('Selected File: $_pickedFileName')
                : const Text('No file selected.'),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFileName = result.files.single.name;
      });

      // You can now use the picked file
      // For example, upload it to a server, open it, etc.
    }
  }
}
