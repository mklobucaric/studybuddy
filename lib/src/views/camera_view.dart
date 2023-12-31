import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';

/// A view that integrates camera functionality for taking and uploading photos.
///
/// This widget uses the CameraService to handle camera operations and interacts
/// with the UploadState for managing photo uploads.
class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final CameraService _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    // Initialize the camera service
    _cameraService.initializeCamera(() {
      if (mounted) {
        setState(() {}); // Refresh the UI when the camera is initialized
      }
    });
  }

  @override
  void dispose() {
    _cameraService
        .dispose(); // Dispose the camera service when the widget is disposed
    super.dispose();
  }

  /// Takes a photo using the camera service.
  ///
  /// This function invokes the camera service to capture a photo.
  Future<void> _takePhoto() async {
    await _cameraService.takePhoto();
    // Optionally, update your state to show a thumbnail of the picture
  }

  /// Handles the photo upload process and navigates to a different view on completion.
  ///
  /// [context] is the BuildContext of the widget.
  /// [languageCode] is the current language code for localization.
  Future<void> _uploadAndClear(
      BuildContext context, String languageCode) async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    await _cameraService.savePhotosToDirectory();

    final String? photosDirPath = _cameraService.photosDirectoryPath;

    if (photosDirPath == null) {
      if (kDebugMode) {
        print('No photos directory path found.');
      }

      return;
    }

    await uploadState.uploadDocumentsFromDirectory(photosDirPath, languageCode);
    await _cameraService.clearPhotos();

    if (!mounted) return;

    if (uploadState.isUploading == false) {
      GoRouter.of(context).go('/questionsAnswers'); // Navigate after uploading
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    // Building the UI for the camera view
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
            Text(localizations?.translate('take_photo') ?? 'Take Photo')
          ],
        ),
      ),
      body: Consumer<UploadState>(
        builder: (context, uploadState, child) {
          if (uploadState.isUploading || !_cameraService.isCameraInitialized) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  child: _cameraService.controller != null
                      ? CameraPreview(_cameraService.controller!)
                      : Text(localizations?.translate('cameraNotAvailable') ??
                          'Camera not available'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _takePhoto,
                      tooltip: 'Take Photo',
                      icon: const Icon(Icons.camera_alt, size: 50),
                    ),
                    IconButton(
                      onPressed: () => _uploadAndClear(
                          context, localeProvider.currentLocale.languageCode),
                      tooltip: 'Upload Photos',
                      icon: const Icon(Icons.cloud_upload, size: 50),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
