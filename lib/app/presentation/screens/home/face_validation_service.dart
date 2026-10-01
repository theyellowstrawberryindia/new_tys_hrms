import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceValidationResult {
  final bool isValid;
  final String message;

  const FaceValidationResult.ok() : isValid = true, message = '';
  const FaceValidationResult.fail(this.message) : isValid = false;
}

class FaceValidationService {
  /// Tune these after testing on real devices.
  static const double _minFaceWidthRatio = 0.30; // face width / photo width
  static const double _maxFaceWidthRatio = 0.95;
  static const double _maxHeadTurn = 20; // degrees left/right
  static const double _maxHeadTilt = 20; // degrees sideways
  static const double _minEyeOpen = 0.3; // 0..1
  static const double _maxOffsetX = 0.20; // face centre vs photo centre
  static const double _maxOffsetY = 0.25;

  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableClassification: true, // needed for eye-open probability
      minFaceSize: 0.2,
    ),
  );

  Future<FaceValidationResult> validate(File file) async {
    /// Upright copy with the EXIF rotation baked in (fixes iOS).
    final normalized = await _normalize(file);

    try {
      final faces = await _detector.processImage(
        InputImage.fromFilePath(normalized.file.path),
      );

      final size = normalized.size;

      log('Face check: ${size.width.toInt()} x ${size.height.toInt()}, '
          'faces = ${faces.length}');

      if (faces.isEmpty) {
        return const FaceValidationResult.fail(
          'No face detected. Please face the camera.',
        );
      }

      if (faces.length > 1) {
        return const FaceValidationResult.fail(
          'Multiple faces detected. Only you should be in the frame.',
        );
      }

      final face = faces.first;
      final box = face.boundingBox;

      // Distance
      final widthRatio = box.width / size.width;
      if (widthRatio < _minFaceWidthRatio) {
        return const FaceValidationResult.fail('Move a little closer.');
      }
      if (widthRatio > _maxFaceWidthRatio) {
        return const FaceValidationResult.fail('Move a little back.');
      }

      // Position
      final dx = (box.center.dx / size.width - 0.5).abs();
      final dy = (box.center.dy / size.height - 0.5).abs();
      if (dx > _maxOffsetX || dy > _maxOffsetY) {
        return const FaceValidationResult.fail(
          'Keep your face inside the frame.',
        );
      }

      // Head pose
      final turn = face.headEulerAngleY?.abs() ?? 0;
      final tilt = face.headEulerAngleZ?.abs() ?? 0;
      if (turn > _maxHeadTurn || tilt > _maxHeadTilt) {
        return const FaceValidationResult.fail(
          'Look straight at the camera.',
        );
      }

      // Eyes
      final left = face.leftEyeOpenProbability;
      final right = face.rightEyeOpenProbability;
      if (left != null &&
          right != null &&
          (left < _minEyeOpen || right < _minEyeOpen)) {
        return const FaceValidationResult.fail('Please keep your eyes open.');
      }

      return const FaceValidationResult.ok();
    } finally {
      try {
        await normalized.file.delete();
      } catch (_) {}
    }
  }

  /// Decodes (Flutter applies the EXIF rotation) and re-saves as an upright
  /// PNG with no EXIF, so ML Kit sees the same orientation on iOS and Android.
  Future<({File file, ui.Size size})> _normalize(File file) async {
    final codec = await ui.instantiateImageCodec(await file.readAsBytes());
    final image = (await codec.getNextFrame()).image;

    final size = ui.Size(image.width.toDouble(), image.height.toDouble());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    image.dispose();
    codec.dispose();

    final out = File(
      '${file.parent.path}/face_check_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await out.writeAsBytes(data!.buffer.asUint8List(), flush: true);

    return (file: out, size: size);
  }

  Future<void> dispose() => _detector.close();
}