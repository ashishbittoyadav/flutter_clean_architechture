import 'package:equatable/equatable.dart';

sealed class BlinkCaptureEvent extends Equatable {
  const BlinkCaptureEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCamera extends BlinkCaptureEvent {}

class FaceDetected extends BlinkCaptureEvent {
  final double? leftEyeOpenProbability;
  final double? rightEyeOpenProbability;

  const FaceDetected({
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
  });

  @override
  List<Object?> get props => [
    leftEyeOpenProbability,
    rightEyeOpenProbability,
  ];
}

class CaptureCompleted extends BlinkCaptureEvent {
  final String path;

  const CaptureCompleted(this.path);

  @override
  List<Object?> get props => [path];
}

class CaptureFailed extends BlinkCaptureEvent {
  final String message;

  const CaptureFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class DisposeCamera extends BlinkCaptureEvent {}