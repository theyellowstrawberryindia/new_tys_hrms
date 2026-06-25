/*
 *  Created by Yellow Strawberry LLP on 27/05/26, 4:23 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 27/05/26, 4:23 pm
 *
 */

import 'dart:io';

import 'package:camera/camera.dart';

import '../../../packages.dart';

class AttendanceCameraScreen extends StatefulWidget {
  const AttendanceCameraScreen({super.key});

  @override
  State<AttendanceCameraScreen> createState() => _AttendanceCameraScreenState();
}

class _AttendanceCameraScreenState extends State<AttendanceCameraScreen> {
  CameraController? controller;

  List<CameraDescription> cameras = [];

  bool isCameraReady = false;

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
    if (controller == null) return;

    final image = await controller!.takePicture();

    /// RETURN IMAGE PATH
    Get.back(result: File(image.path));
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: isCameraReady == false
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(controller!),

                /// FACE GUIDE
                Center(
                  child: Container(
                    width: 280,
                    height: 360,

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
