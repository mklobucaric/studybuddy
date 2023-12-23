import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class CameraService {
  CameraController? _controller;
  final List<XFile> _takenPhotos = [];
  // The private variable holding the directory path
  String? _photosDirectoryPath;
  // Getter to retrieve the photos directory path
  String? get photosDirectoryPath => _photosDirectoryPath;
  bool _isCameraInitialized = false; // New flag for initialization status

  // Getter for the CameraController
  CameraController? get controller => _controller;

  // Getter for camera initialization status
  bool get isCameraInitialized => _isCameraInitialized;

  // Dispose method to release the camera resources
  Future<void> dispose() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.dispose();
      } catch (e) {
        // Log or handle the exception
        print('Error disposing camera controller: $e');
      }
      _controller = null;
    }
  }

  Future<void> initializeCamera(Function onCameraInitialized) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller =
            CameraController(cameras.first, ResolutionPreset.veryHigh);
        await _controller!.initialize();
        _isCameraInitialized =
            true; // Update the flag when initialization is complete
        onCameraInitialized(); // Call the passed callback function
      } else {
        throw 'No cameras available'; // Custom exception
      }
    } catch (e) {
      // Handle the error appropriately
      print('Error initializing camera: $e');
      _isCameraInitialized = false; // Update the flag in case of an error
      rethrow;
      // or handle it differently (e.g., notify users, log to a service, etc.)
    }
  }

  Future<void> takePhoto() async {
    if (_controller?.value.isInitialized == true) {
      XFile file = await _controller!.takePicture();
      _takenPhotos.add(file);
      // Optionally, you could immediately save the photo to a directory here.
    }
  }

  Future<void> savePhotosToDirectory() async {
    // Get the directory where the app can save files
    final Directory extDir = await getApplicationDocumentsDirectory();
    // Format the current date
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Create the directory path
    final String dirPath = '${extDir.path}/Photos_$formattedDate';
    // Create the directory if it doesn't already exist
    await Directory(dirPath).create(recursive: true);
    // Store the directory path in a member variable
    _photosDirectoryPath = dirPath;

    // Iterate over the taken photos
    for (int i = 0; i < _takenPhotos.length; i++) {
      // Create a file path for each photo
      final String filePath = path.join(dirPath,
          '${i + 1}.jpg'); // Starts naming photos from 1.jpg, 2.jpg, and so on
      // Save the photo to the file path
      await _takenPhotos[i].saveTo(filePath);
    }
    // Clear the photos list after saving them
    _takenPhotos.clear();
  }

  Future<void> clearPhotos() async {
    if (_photosDirectoryPath != null) {
      final dir = Directory(_photosDirectoryPath!);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    }
  }
}
