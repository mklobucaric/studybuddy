import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class CameraService {
  CameraController? _controller;
  final List<XFile> _takenPhotos =
      []; // List to store photos taken by the camera
  String? _photosDirectoryPath; // Directory path where photos will be saved

  // Getter to retrieve the photos directory path
  String? get photosDirectoryPath => _photosDirectoryPath;

  bool _isCameraInitialized =
      false; // Flag indicating if the camera is initialized

  // Getter for the CameraController
  CameraController? get controller => _controller;

  // Getter for camera initialization status
  bool get isCameraInitialized => _isCameraInitialized;

  /// Releases the camera resources.
  ///
  /// Disposes the CameraController and sets it to null.
  Future<void> dispose() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.dispose();
      } catch (e) {
        if (kDebugMode) {
          print('Error disposing camera controller: $e');
        }
      }
      _controller = null;
    }
  }

  /// Initializes the camera.
  ///
  /// [onCameraInitialized] is a callback function to execute after initialization.
  /// Throws an exception if no cameras are available.
  Future<void> initializeCamera(Function onCameraInitialized) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller =
            CameraController(cameras.first, ResolutionPreset.veryHigh);
        await _controller!.initialize();
        _isCameraInitialized =
            true; // Set flag to true after successful initialization
        onCameraInitialized(); // Execute the callback function
      } else {
        throw 'No cameras available'; // Custom exception for no available cameras
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }

      _isCameraInitialized = false;
      rethrow;
    }
  }

  /// Takes a photo using the camera.
  ///
  /// Captures a photo and adds it to the list of taken photos.
  Future<void> takePhoto() async {
    if (_controller?.value.isInitialized == true) {
      XFile file = await _controller!.takePicture();
      _takenPhotos.add(file);
    }
  }

  /// Saves the taken photos to a directory.
  ///
  /// Creates a new directory with the current date and saves all taken photos there.
  /// Clears the photos list after saving.
  Future<void> savePhotosToDirectory() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String dirPath = '${extDir.path}/Photos_$formattedDate';
    await Directory(dirPath).create(recursive: true);
    _photosDirectoryPath = dirPath;

    for (int i = 0; i < _takenPhotos.length; i++) {
      final String filePath = path.join(dirPath, '${i + 1}.jpg');
      await _takenPhotos[i].saveTo(filePath);
    }
    _takenPhotos.clear();
  }

  /// Clears the photos from the directory.
  ///
  /// Deletes the directory containing the saved photos.
  Future<void> clearPhotos() async {
    if (_photosDirectoryPath != null) {
      final dir = Directory(_photosDirectoryPath!);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    }
  }
}
