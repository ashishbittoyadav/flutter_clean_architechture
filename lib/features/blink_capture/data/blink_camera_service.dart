import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class BlinkCameraService {
  CameraController? _controller;

  CameraController? get controller => _controller;

  // final FaceDetector _faceDetector = FaceDetector(
  //   options: FaceDetectorOptions(
  //     enableClassification: true,
  //     enableTracking: true,
  //     performanceMode: FaceDetectorMode.fast,
  //     minFaceSize: 0.15,
  //   ),
  // );

  bool _isProcessingFrame = false;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: kIsWeb
          ? ImageFormatGroup.unknown
          : defaultTargetPlatform == TargetPlatform.android
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller!.initialize();
  }

  // Future<void> startImageStream(
  //     void Function(Face face) onFaceDetected,
  //     ) async {
  //   if (_controller == null) {
  //     throw StateError('Camera is not initialized');
  //   }
  //
  //   await _controller!.startImageStream(
  //         (CameraImage image) async {
  //       if (_isProcessingFrame) {
  //         return;
  //       }
  //
  //       _isProcessingFrame = true;
  //
  //       // try {
  //         // final inputImage = _convertCameraImage(image);
  //         //
  //         // if (inputImage == null) {
  //         //   return;
  //         // }
  //
  //       //   final faces = await _faceDetector.processImage(inputImage);
  //       //
  //       //   if (faces.isNotEmpty) {
  //       //     onFaceDetected(faces.first);
  //       //   }
  //       // } finally {
  //       //   _isProcessingFrame = false;
  //       // }
  //     },
  //   );
  // }

  Future<XFile> takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized) {
      throw StateError('Camera is not initialized');
    }

    if (_controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }

    return _controller!.takePicture();
  }

  // InputImage? _convertCameraImage(CameraImage image) {
  //   final controller = _controller;
  //
  //   if (controller == null) {
  //     return null;
  //   }
  //
  //   final camera = controller.description;
  //
  //   final sensorOrientation = camera.sensorOrientation;
  //
  //   final rotation = InputImageRotationValue.fromRawValue(
  //     sensorOrientation,
  //   );
  //
  //   if (rotation == null) {
  //     return null;
  //   }
  //
  //   final format = InputImageFormatValue.fromRawValue(
  //     image.format.raw,
  //   );
  //
  //   if (format == null) {
  //     return null;
  //   }
  //
  //   final bytes = _concatenatePlanes(image.planes);
  //
  //   final metadata = InputImageMetadata(
  //     size: Size(
  //       image.width.toDouble(),
  //       image.height.toDouble(),
  //     ),
  //     rotation: rotation,
  //     format: format,
  //     bytesPerRow: image.planes.first.bytesPerRow,
  //   );
  //
  //   return InputImage.fromBytes(
  //     bytes: bytes,
  //     metadata: metadata,
  //   );
  // }

  Uint8List _concatenatePlanes(
      List<Plane> planes,
      ) {
    final bytes = WriteBuffer();

    for (final plane in planes) {
      bytes.putUint8List(plane.bytes);
    }

    return bytes.done().buffer.asUint8List();
  }

  Future<void> dispose() async {
    // await _faceDetector.close();
    await _controller?.dispose();
  }
}