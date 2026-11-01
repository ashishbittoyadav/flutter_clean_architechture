import 'package:equatable/equatable.dart';

enum BlinkCaptureStatus {
  initial,
  initializing,
  ready,
  blinkDetected,
  capturing,
  captured,
  error,
}

class BlinkCaptureState extends Equatable {
  final BlinkCaptureStatus status;
  final String? imagePath;
  final String? errorMessage;

  final double? leftEyeProbability;
  final double? rightEyeProbability;

  const BlinkCaptureState({
    this.status = BlinkCaptureStatus.initial,
    this.imagePath,
    this.errorMessage,
    this.leftEyeProbability,
    this.rightEyeProbability,
  });

  BlinkCaptureState copyWith({
    BlinkCaptureStatus? status,
    String? imagePath,
    String? errorMessage,
    double? leftEyeProbability,
    double? rightEyeProbability,
  }) {
    return BlinkCaptureState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
      leftEyeProbability:
      leftEyeProbability ?? this.leftEyeProbability,
      rightEyeProbability:
      rightEyeProbability ?? this.rightEyeProbability,
    );
  }

  @override
  List<Object?> get props => [
    status,
    imagePath,
    errorMessage,
    leftEyeProbability,
    rightEyeProbability,
  ];
}