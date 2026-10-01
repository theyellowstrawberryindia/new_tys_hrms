/*
 *  Created by Yellow Strawberry LLP on 27/05/26, 4:23 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 27/05/26, 4:23 pm
 *
 */

import 'dart:io';

import 'package:camera/camera.dart';

import '../../../packages.dart';
import '../../../widgets/image_timestamp.dart';
import 'face_validation_service.dart';

class AttendanceCameraScreen extends StatefulWidget {
  final String address;

  const AttendanceCameraScreen({super.key, this.address = ""});

  @override
  State<AttendanceCameraScreen> createState() => _AttendanceCameraScreenState();
}

class _AttendanceCameraScreenState extends State<AttendanceCameraScreen> {
  CameraController? controller;

  List<CameraDescription> cameras = [];

  final _faceService = FaceValidationService();

  bool isCameraReady = false;

  /// Plain flag (no setState) to block double taps before the loader shows.
  bool _isCapturing = false;

  /// Guide width as a fraction of screen width (the guide is a square).
  static const double _guideFactor = 0.9;

  /// Set during build, used at capture time to map guide -> photo pixels.
  Size _viewSize = Size.zero;
  double _guideSide = 0;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      frontCamera,

      ResolutionPreset.high,

      enableAudio: false,
    );

    await controller!.initialize();

    if (!mounted) return;

    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> _captureImage() async {
    if (controller == null || _isCapturing) return;

    _isCapturing = true;

    Loader.showLoader();

    try {
      final capturedAt = DateTime.now();

      final XFile image = await controller!.takePicture();
      // final XFile image = await controller!.takePicture();

      /// FACE CHECK (on the original photo, before crop/stamp)
      final check = await _faceService.validate(File(image.path));

      if (!check.isValid) {
        Loader.hideLoader();

        _isCapturing = false;

        try {
          await File(image.path).delete();
        } catch (_) {}

        Toast.error(message: check.message);

        return;
      }

      final File stamped = await ImageTimestamp.stamp(
        File(image.path),
        time: capturedAt,
        address: widget.address,
        viewSize: _viewSize,
        guideSide: _guideSide,
      );
      // final File stamped = await ImageTimestamp.stamp(
      //   File(image.path),
      //   time: capturedAt,
      //   address: widget.address,
      //   viewSize: _viewSize,
      //   guideSide: _guideSide,
      // );

      /// Close the loader FIRST, otherwise Get.back() below
      /// would pop the dialog instead of this camera screen.
      Loader.hideLoader();

      Get.back(result: stamped); // .png, 1:1
    } catch (e) {
      Loader.hideLoader();

      _isCapturing = false;

      Toast.error(message: e.toString());
    }
  }

  /// Full-screen "cover" preview: fills the screen, overflow is clipped.
  Widget _buildFullScreenPreview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewSize = constraints.biggest;

        return ClipRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: constraints.maxWidth,
              // aspectRatio is landscape (w/h), so portrait height = width * ratio
              height: constraints.maxWidth * controller!.value.aspectRatio,
              child: CameraPreview(controller!),
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _faceService.dispose();
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    _guideSide = screenW * _guideFactor;

    return Scaffold(
      backgroundColor: Colors.black,

      body: isCameraReady == false
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          /// FULL SCREEN PREVIEW
          Positioned.fill(child: _buildFullScreenPreview()),

          /// FACE GUIDE (3:4 = the area that gets saved)
          Center(
            child: Container(
              width: _guideSide,
              height: _guideSide * ImageTimestamp.cropAspect,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          /// TEXT
          Positioned(
            top: 80,
            left: 20,
            right: 20,

            child: Text(
              "Align your face inside the frame",

              textAlign: TextAlign.center,

              style: AppTheme.textStyle(
                size: 18,

                weight: FontWeight.w600,

                color: Colors.white,
              ),
            ),
          ),

          /// CAPTURE BUTTON
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,

            child: Center(
              child: GestureDetector(
                onTap: _captureImage,

                child: Container(
                  width: 80,
                  height: 80,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(color: Colors.white, width: 6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}