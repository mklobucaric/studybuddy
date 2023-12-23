import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/camera_service.dart'; // Ensure this import points to the correct location of your CameraService
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/states/upload_state.dart';
import 'package:studybuddy/src/utils/localization.dart';
import 'package:studybuddy/src/controllers/locale_provider.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final CameraService _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    _cameraService.initializeCamera(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _cameraService.dispose(); // Dispose the camera service
    super.dispose();
  }

  Future<void> _takePhoto() async {
    await _cameraService.takePhoto();
    // Optionally, update your state to show a thumbnail of the picture
  }

  Future<void> _uploadAndClear(context, String languageCode) async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    await _cameraService.savePhotosToDirectory();

    final String? photosDirPath = _cameraService.photosDirectoryPath;

    if (photosDirPath == null) {
      print('No photos directory path found.');
      return;
    }

    await uploadState.uploadDocumentsFromDirectory(photosDirPath, languageCode);
    await _cameraService.clearPhotos();

    // Check if the widget is still mounted before using the context
    if (!mounted) return;

    if (uploadState.isUploading == false) {
      GoRouter.of(context).go('/questionsAnswers');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final uploadState = Provider.of<UploadState>(context, listen: false);
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
            Text(localizations?.translate('take_photo') ?? 'Take Photo')
          ],
        ),
      ),
      body: Consumer<UploadState>(
        builder: (context, uploadState, child) {
          // Check if either camera is initializing or upload is in progress
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
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: _takePhoto,
                      tooltip: 'Take Photo',
                      icon: const Icon(Icons.camera_alt, size: 50),
                      color: Theme.of(context)
                          .iconTheme
                          .color, // Keeping the theme color
                    ),
                    const SizedBox(width: 30),
                    IconButton(
                      onPressed: () => _uploadAndClear(
                          context, localeProvider.currentLocale.languageCode),
                      tooltip: 'Upload Photos',
                      icon: const Icon(Icons.cloud_upload, size: 50),
                      color: Theme.of(context).iconTheme.color,
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
