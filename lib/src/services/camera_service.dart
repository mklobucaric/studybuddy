import 'package:camera/camera.dart';
import 'dart:async';

class CameraService {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras.first, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
    } else {
      throw 'No cameras available';
    }
  }

  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw 'Error: Initialize the camera first.';
    }

    if (_controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _initializeControllerFuture;
      final file = await _controller!.takePicture();
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
