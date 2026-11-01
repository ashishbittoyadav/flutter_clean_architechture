import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blink_capture_bloc.dart';
import '../bloc/blink_capture_event.dart';
import '../bloc/blink_capture_state.dart';
import '../data/blink_camera_service.dart';

class BlinkCaptureScreen extends StatelessWidget {
  const BlinkCaptureScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlinkCaptureBloc(
        cameraService: BlinkCameraService(),
      )..add(InitializeCamera()),
      child: const _BlinkCaptureView(),
    );
  }
}

class _BlinkCaptureView extends StatelessWidget {
  const _BlinkCaptureView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blink Capture'),
      ),
      body: BlocConsumer<
          BlinkCaptureBloc,
          BlinkCaptureState>(
        listener: (context, state) {
          if (state.status ==
              BlinkCaptureStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Something went wrong',
                ),
              ),
            );
          }

          if (state.status ==
              BlinkCaptureStatus.captured) {
            debugPrint(
              'Captured: ${state.imagePath}',
            );
          }
        },
        builder: (context, state) {
          if (state.status ==
              BlinkCaptureStatus.initializing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              BlinkCaptureStatus.captured) {
            return _CapturedImage(
              path: state.imagePath!,
            );
          }

          final bloc =
          context.read<BlinkCaptureBloc>();

          final controller =
              bloc.cameraService.controller;

          if (controller == null ||
              !controller.value.isInitialized) {
            return const Center(
              child: Text(
                'Camera unavailable',
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),

              const _FaceOverlay(),

              Positioned(
                left: 20,
                right: 20,
                bottom: 40,
                child: _StatusMessage(
                  state: state,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CapturedImage extends StatelessWidget {
  final String path;

  const _CapturedImage({
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.file(
            File(path),
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // Upload / continue
            },
            child: const Text(
              'Use Photo',
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final BlinkCaptureState state;

  const _StatusMessage({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    String message;

    switch (state.status) {
      case BlinkCaptureStatus.ready:
        message =
        'Look at the camera and blink';
        break;

      case BlinkCaptureStatus.capturing:
        message = 'Capturing...';
        break;

      case BlinkCaptureStatus.blinkDetected:
        message = 'Blink detected';
        break;

      default:
        message = 'Position your face';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _FaceOverlay extends StatelessWidget {
  const _FaceOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 260,
          height: 340,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius:
            BorderRadius.circular(180),
          ),
        ),
      ),
    );
  }
}