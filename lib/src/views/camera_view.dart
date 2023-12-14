import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/camera_service.dart'; // Ensure this import points to the correct location of your CameraService
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/controllers/document_controller.dart';
import 'package:studybuddy/src/states/upload_state.dart';

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

  Future<void> _uploadAndClear() async {
    final uploadState = Provider.of<UploadState>(context, listen: false);
    await _cameraService.savePhotosToDirectory();

    final String? photosDirPath = _cameraService.photosDirectoryPath;

    if (photosDirPath == null) {
      print('No photos directory path found.');
      return;
    }

    await uploadState.uploadDocumentsFromDirectory(photosDirPath);
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
    final documentController = Provider.of<DocumentController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Photos'),
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
                    return Text("Camera not available");
                  }
                } else {
                  // Otherwise, display a loading indicator
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          if (documentController.isUploading)
            const LinearProgressIndicator(), // Shows a progress bar when uploading
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _takePicture,
                tooltip: 'Take Photo',
                child: Icon(Icons.camera_alt),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _uploadAndClear,
                tooltip: 'Upload Photos',
                child: Icon(Icons.cloud_upload),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
