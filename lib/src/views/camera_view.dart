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
    _cameraService.initializeCamera();
  }

  Future<void> _takePicture() async {
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
      GoRouter.of(context).go('/questions_answers');
    }
  }

  // // Call the ApiService to upload the photos
  // bool uploadSuccess = await _apiService.uploadDocuments(photosDirPath);
  // if (uploadSuccess) {
  //   await _cameraService.clearPhotos();
  //   GoRouter.of(context)
  //       .go('/questions_answers'); // Adjust the route as needed
  //   // Here you would also update your state to reflect that the photos are cleared
  // } else {
  //   // Handle upload failure (e.g., retry, show an error message)
  // }

  @override
  Widget build(BuildContext context) {
    final uploadState = Provider.of<UploadState>(context, listen: false);
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
      body: Column(
        children: [
          Expanded(
            child:
                // Display the camera preview here,
                FutureBuilder<void>(
              future: _cameraService.initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview
                  // Ensure that _cameraService.controller is not null
                  if (_cameraService.controller != null) {
                    return CameraPreview(_cameraService.controller!);
                  } else {
                    return Text(
                        localizations?.translate('cameraNotAvailable') ??
                            'Camera not available');
                  }
                } else {
                  // Otherwise, display a loading indicator
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          if (uploadState.isUploading)
            const LinearProgressIndicator(), // Shows a progress bar when uploading
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _takePicture,
                tooltip: 'Take Photo',
                child: const Icon(Icons.camera_alt),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: () => _uploadAndClear(
                    context, localeProvider.currentLocale.languageCode),
                tooltip: 'Upload Photos',
                child: const Icon(Icons.cloud_upload),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
