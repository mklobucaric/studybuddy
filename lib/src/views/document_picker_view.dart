import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/services/file_picker_service.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:go_router/go_router.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';

/// A view for picking and uploading documents.
///
/// This widget allows users to select documents from their device and upload them
/// using the application's upload service.
class DocumentPickerView extends StatefulWidget {
  const DocumentPickerView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DocumentPickerViewState createState() => _DocumentPickerViewState();
}

class _DocumentPickerViewState extends State<DocumentPickerView> {
  List<PlatformFile> _pickedFiles = []; // List to store picked files

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                GoRouter.of(context).go('/home'); // Navigation to home
              },
              child: const Text('Study Buddy'),
            ),
            Text(localizations?.translate('pickDocumentsTitle') ?? 'Pick Docs')
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildActionIcons(context, localizations),
                    const SizedBox(height: 20),
                    _buildFileList(localizations),
                  ],
                ),
              ),
              if (isUploading)
                const LinearProgressIndicator(), // Show progress indicator when uploading
            ],
          );
        },
      ),
    );
  }

  /// Builds a widget displaying action icons for picking and uploading documents.
  ///
  /// [context] is the current BuildContext.
  /// [localizations] is used to access localized strings.
  Widget _buildActionIcons(
      BuildContext context, AppLocalizations? localizations) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.attach_file, size: 50),
          onPressed: _pickDocuments,
          color: Theme.of(context).iconTheme.color,
          tooltip:
              localizations?.translate('pick_documents') ?? 'Pick Documents',
        ),
        const SizedBox(width: 30),
        IconButton(
          icon: const Icon(Icons.cloud_upload, size: 50),
          onPressed: () => _uploadDocuments(
              context, localeProvider.currentLocale.languageCode),
          color: Theme.of(context).iconTheme.color,
          tooltip: localizations?.translate('upload_documents') ??
              'Upload Documents',
        ),
      ],
    );
  }

  /// Builds a widget displaying the list of picked files.
  ///
  /// [localizations] is used to access localized strings.
  Widget _buildFileList(AppLocalizations? localizations) {
    if (_pickedFiles.isNotEmpty) {
      return Column(
        children: _pickedFiles.map((file) => Text(file.name)).toList(),
      );
    } else {
      return Column(
        children: [
          Text(localizations?.translate('noFilesSelected') ??
              'No files selected.'),
        ],
      );
    }
  }

  /// Invokes the file picker service to select multiple files.
  ///
  /// Once files are picked, updates the state with the selected files.
  Future<void> _pickDocuments() async {
    final filePickerService = FilePickerService();
    final results = await filePickerService.pickMultipleFiles();

    if (results != null) {
      setState(() {
        _pickedFiles = results.files;
      });
    }
  }

  /// Uploads the selected documents and navigates to another view upon completion.
  ///
  /// [context] is the current BuildContext.
  /// [languageCode] is the current language code for localization.
  Future<void> _uploadDocuments(
      BuildContext context, String languageCode) async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    if (_pickedFiles.isNotEmpty) {
      await uploadState.uploadDocuments(_pickedFiles, languageCode);

      if (!mounted) return;
      if (!uploadState.isUploading) {
        GoRouter.of(context)
            .go('/questionsAnswers'); // Navigate after uploading
      }
    }
  }
}
