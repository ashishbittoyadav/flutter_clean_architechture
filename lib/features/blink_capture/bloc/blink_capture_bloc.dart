import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/blink_camera_service.dart';
import 'blink_capture_event.dart';
import 'blink_capture_state.dart';

class BlinkCaptureBloc
    extends Bloc<BlinkCaptureEvent, BlinkCaptureState> {
  final BlinkCameraService cameraService;

  bool _eyesWereOpen = false;
  bool _blinkInProgress = false;

  DateTime? _lastCaptureTime;

  BlinkCaptureBloc({
    required this.cameraService,
  }) : super(const BlinkCaptureState()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<FaceDetected>(_onFaceDetected);
    on<CaptureCompleted>(_onCaptureCompleted);
    on<CaptureFailed>(_onCaptureFailed);
    on<DisposeCamera>(_onDisposeCamera);
  }

  Future<void> _onInitializeCamera(
      InitializeCamera event,
      Emitter<BlinkCaptureState> emit,
      ) async {
    emit(
      state.copyWith(
        status: BlinkCaptureStatus.initializing,
      ),
    );

    try {
      await cameraService.initialize();

      emit(
        state.copyWith(
          status: BlinkCaptureStatus.ready,
        ),
      );

      // await cameraService.startImageStream(
      //       (face) {
      //     // add(
      //     //   // FaceDetected(
      //     //   //   leftEyeOpenProbability:
      //     //   //   face.leftEyeOpenProbability,
      //     //   //   rightEyeOpenProbability:
      //     //   //   face.rightEyeOpenProbability,
      //     //   // ),
      //     // );
      //   },
      // );
    } catch (e) {
      emit(
        state.copyWith(
          status: BlinkCaptureStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFaceDetected(
      FaceDetected event,
      Emitter<BlinkCaptureState> emit,
      ) async {
    final left = event.leftEyeOpenProbability;
    final right = event.rightEyeOpenProbability;

    if (left == null || right == null) {
      return;
    }

    emit(
      state.copyWith(
        leftEyeProbability: left,
        rightEyeProbability: right,
      ),
    );

    final eyesOpen =
        left > 0.60 &&
            right > 0.60;

    final eyesClosed =
        left < 0.25 &&
            right < 0.25;

    // Initial state.
    if (!_eyesWereOpen && eyesOpen) {
      _eyesWereOpen = true;
      return;
    }

    // Blink starts.
    if (_eyesWereOpen && eyesClosed) {
      _blinkInProgress = true;
      return;
    }

    // Blink completed.
    if (_blinkInProgress && eyesOpen) {
      _blinkInProgress = false;
      _eyesWereOpen = true;

      await _capture();

      return;
    }
  }

  Future<void> _capture() async {
    if (state.status == BlinkCaptureStatus.capturing ||
        state.status == BlinkCaptureStatus.captured) {
      return;
    }

    final now = DateTime.now();

    if (_lastCaptureTime != null &&
        now.difference(_lastCaptureTime!) <
            const Duration(seconds: 2)) {
      return;
    }

    _lastCaptureTime = now;

    emit(
      state.copyWith(
        status: BlinkCaptureStatus.capturing,
      ),
    );

    try {
      final XFile file =
      await cameraService.takePicture();

      add(
        CaptureCompleted(file.path),
      );
    } catch (e) {
      add(
        CaptureFailed(e.toString()),
      );
    }
  }

  void _onCaptureCompleted(
      CaptureCompleted event,
      Emitter<BlinkCaptureState> emit,
      ) {
    emit(
      state.copyWith(
        status: BlinkCaptureStatus.captured,
        imagePath: event.path,
      ),
    );
  }

  void _onCaptureFailed(
      CaptureFailed event,
      Emitter<BlinkCaptureState> emit,
      ) {
    emit(
      state.copyWith(
        status: BlinkCaptureStatus.error,
        errorMessage: event.message,
      ),
    );
  }

  Future<void> _onDisposeCamera(
      DisposeCamera event,
      Emitter<BlinkCaptureState> emit,
      ) async {
    await cameraService.dispose();
  }

  @override
  Future<void> close() async {
    await cameraService.dispose();
    return super.close();
  }
}