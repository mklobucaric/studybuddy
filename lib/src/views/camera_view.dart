import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/camera_service.dart'; // Ensure this import points to the correct location of your CameraService
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/src/controllers/document_controller.dart';

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
    await _cameraService.savePhotosToDirectory();

    // Get the photos directory path from the camera service
    final String? photosDirPath = _cameraService.photosDirectoryPath;

    if (photosDirPath == null) {
      // Handle the case where the directory path is not available
      print('No photos directory path found.');
      return;
    }

    final documentController =
        Provider.of<DocumentController>(context, listen: false);

    // Start the upload process
    documentController.uploadDocument(photosDirPath);

    // Use a local variable to store whether the widget is still mounted
    bool isMounted = mounted;

    // Check if the widget is still mounted before trying to use the context
    documentController.addListener(() {
      if (isMounted) {
        if (documentController.isUploading == false) {
          // If the upload is complete, navigate or update the UI
          GoRouter.of(context)
              .go('/questions_answers'); // Adjust the route as needed
        }
      }
    });

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
  }

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
