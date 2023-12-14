import 'package:flutter/material.dart';
import 'package:studybuddy/src/services/camera_service.dart'; // Ensure this import points to the correct location of your CameraService
import 'package:studybuddy/src/services/api_service.dart';
import 'package:camera/camera.dart';

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
    // Call the ApiService to upload the photos
    bool uploadSuccess = await ApiService.uploadDocuments(photosDirPath);
    if (uploadSuccess) {
      await _cameraService.clearPhotos();
      // Here you would also update your state to reflect that the photos are cleared
    } else {
      // Handle upload failure (e.g., retry, show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
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
