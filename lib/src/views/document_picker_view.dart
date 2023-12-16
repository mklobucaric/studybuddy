import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/services/file_picker_service.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';

class DocumentPickerView extends StatefulWidget {
  const DocumentPickerView({super.key});

  @override
  _DocumentPickerViewState createState() => _DocumentPickerViewState();
}

class _DocumentPickerViewState extends State<DocumentPickerView> {
  List<String>? _pickedFilePaths; // Store file paths instead of just names

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Use go_router to navigate to HomeView
                GoRouter.of(context).go('/home');
              },
              child: const Text('Study Buddy'),
            ),
            Text(localizations?.translate('pickDocumentsTitle') ??
                'Pick Documents')
          ],
        ),
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
                      child: Text(localizations?.translate('selectDocuments') ??
                          'Select Documents'),
                    ),
                    ElevatedButton(
                      onPressed: () => _uploadDocuments(
                          context, localeProvider.currentLocale.languageCode),
                      child: Text(localizations?.translate('uploadDocuments') ??
                          'Upload Documents'),
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
    var localizations = AppLocalizations.of(context);
    if (_pickedFilePaths != null) {
      return Column(
        children: _pickedFilePaths!
            .map((path) => Text(path.split('/').last))
            .toList(),
      );
    } else {
      return Text(
          localizations?.translate('noFilesSelected') ?? 'No files selected.');
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

  Future<void> _uploadDocuments(context, String languageCode) async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    if (_pickedFilePaths != null) {
      await uploadState.uploadDocuments(_pickedFilePaths!, languageCode);

      // If the widget is still mounted and upload is complete, navigate to another view
      if (!mounted) return;
      if (!uploadState.isUploading) {
        GoRouter.of(context).go(
            '/questions_answers'); // Replace '/next_route' with your desired route
      }
    }
  }
}
