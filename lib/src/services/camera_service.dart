import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class CameraService {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final List<XFile> _takenPhotos = [];
  // The private variable holding the directory path
  String? _photosDirectoryPath;
  // Getter to retrieve the photos directory path
  String? get photosDirectoryPath => _photosDirectoryPath;
  // Getter for _initializeControllerFuture
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;
  // Getter for the CameraController
  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras.first, ResolutionPreset.veryHigh);
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture; // Await the future here
    } else {
      throw 'No cameras available';
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

  // Future<void> takeAndSavePhoto() async {
  //   // Ensure the controller is initialized before attempting to take a picture
  //   if (_controller == null) {
  //     throw Exception('CameraController is not created');
  //   }

  //   if (!_controller!.value.isInitialized) {
  //     throw Exception('Camera is not initialized');
  //   }
  //   try {
  //     // Take the photo
  //     final XFile photo = await _controller!.takePicture();

  //     // Get the directory to save photos
  //     final Directory appDocDir = await getApplicationDocumentsDirectory();
  //     final String photosDirPath = path.join(
  //         appDocDir.path, 'photos_${DateTime.now().toIso8601String()}');
  //     final Directory photosDir =
  //         await Directory(photosDirPath).create(recursive: true);

  //     // Save the photo to the directory
  //     final String photoPath =
  //         path.join(photosDir.path, 'photo_${_takenPhotos.length + 1}.jpg');
  //     await photo.saveTo(photoPath);

  //     // Add the photo to the list of taken photos
  //     _takenPhotos.add(photo);
  //   } catch (e) {
  //     // Handle exceptions, possibly by showing an error message to the user
  //   }
  // }
}
