// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mnm_vendor/screens/face_id_page.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/providers/provider.dart';

class IDVerificationScreen extends ConsumerStatefulWidget {
  const IDVerificationScreen({
    super.key,
    required this.onComplete,
  });
  final VoidCallback onComplete;
  static const routeName = 'uploadid-page';

  @override
  ConsumerState<IDVerificationScreen> createState() =>
      _IDVerificationScreenState();
}

class _IDVerificationScreenState extends ConsumerState<IDVerificationScreen> {
  CameraController? _cameraController;
  File? _frontImage;
  String _extractedFrontText = '';
  bool _faceDetected = false;

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.first;

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;

    final image = await _cameraController!.takePicture();
    setState(() {
      _frontImage = File(image.path);
      _extractTextFromImage(_frontImage!);
      _detectFaces(_frontImage!); // Call face detection
    });
  }

  Future<void> _extractTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      _extractedFrontText = recognizedText.text;
    });

    textRecognizer.close();
  }

  Future<void> _detectFaces(File image) async {
    final inputImage = InputImage.fromFile(image);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);

    setState(() {
      _faceDetected = faces.isNotEmpty;
    });

    faceDetector.close();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('front_image_path', path);
  }

  @override
  Widget build(BuildContext context) {
    final completedSteps = ref.watch(stepStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghana Card verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'NB: Your account will not be validated if the picture is not clear',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CameraPreview(_cameraController!))),
                    )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
              CustomButton(
                onTap: _takePicture,
                title: 'Take Picture',
              ),
              const SizedBox(height: 20),
              if (_frontImage != null)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _frontImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // if (_extractedFrontText.isNotEmpty)
              //   Text('Extracted Front Text: $_extractedFrontText'),
              // const SizedBox(height: 20),
              if (_frontImage != null)
                _faceDetected && _extractedFrontText.isNotEmpty
                    ? CustomButton(
                        onTap: () async {
                          await _saveImagePath(_frontImage!.path);
                          widget.onComplete();
                          Navigator.pushNamed(
                            context,
                            FaceDetectionPage.routeName,
                          );
                        },
                        title: 'Save and continue')
                    : const Center(
                        child: Text(
                            'No Face Detected and failed to recognize text\n Please retake picture',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red)),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
