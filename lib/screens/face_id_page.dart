import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mnm_vendor/screens/bussiness_info.dart';
import 'package:mnm_vendor/screens/dashboard_fragments/verification_page.dart';
import 'package:mnm_vendor/utils/user_verification.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceDetectionPage extends ConsumerStatefulWidget {
  const FaceDetectionPage({required this.onComplete, super.key});
  static const routeName = 'face-detection-page';
  final VoidCallback onComplete;
  @override
  FaceDetectionPageState createState() => FaceDetectionPageState();
}

class FaceDetectionPageState extends ConsumerState<FaceDetectionPage> {
  late CameraController _cameraController;
  bool isDetecting = false;
  bool faceDetected = false;
  XFile? _capturedImage;
  bool isCameraInitialized = false;
  CameraLensDirection cameraDirection =
      CameraLensDirection.front; // Track current camera

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndInitializeCamera();
  }

  Future<void> _requestPermissionsAndInitializeCamera() async {
    if (await Permission.camera.request().isGranted) {
      initializeCamera();
    } else {
      // Handle permission denied state
      showPermissionDeniedDialog();
    }
  }

  Future<void> showPermissionDeniedDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission"),
        content:
            const Text("Camera permission is required to use this feature."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();

    // Get the current camera direction (front or back)
    CameraDescription? selectedCamera;
    for (var camera in cameras) {
      if (camera.lensDirection == cameraDirection) {
        selectedCamera = camera;
        break;
      }
    }

    if (selectedCamera != null) {
      setState(() {
        _cameraController = CameraController(
          selectedCamera!,
          ResolutionPreset.medium,
        );
      });

      await _cameraController.initialize();
      setState(() {
        isCameraInitialized = true;
      });

      // Start image stream and detect face
      _cameraController.startImageStream((CameraImage image) {
        if (!isDetecting) {
          isDetecting = true;
          detectFace(image);
        }
      });
    } else {
      // Handle if no camera is found
      print('No camera found.');
    }
  }

  void toggleCamera() {
    setState(() {
      isCameraInitialized = false; // Set it to false while reinitializing
    });
    // Toggle between front and back cameras
    setState(() {
      cameraDirection = cameraDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;

      // Reinitialize the camera with the new direction
      _cameraController.dispose(); // Dispose the previous camera controller
      initializeCamera(); // Initialize the new camera
    });
  }

  Future<void> detectFace(CameraImage image) async {
    try {
      final inputImage = convertCameraImageToInputImage(image);
      final List<Face> faces = await faceDetector.processImage(inputImage);

      setState(() {
        faceDetected = faces.isNotEmpty;
      });
    } catch (e) {
      print("Error detecting face: $e");
    } finally {
      // Delay next detection to avoid processing overload
      await Future.delayed(const Duration(milliseconds: 500));
      isDetecting = false;
    }
  }

  InputImage convertCameraImageToInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final InputImageRotation rotation =
        cameraDirection == CameraLensDirection.front
            ? InputImageRotation.rotation270deg
            : InputImageRotation.rotation90deg;
    final inputImage = InputImage.fromBytes(
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
      bytes: bytes,
    );
    return inputImage;
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('face_image_path', path);
  }

  void captureFace() async {
    if (faceDetected) {
      XFile picture = await _cameraController.takePicture();
      setState(() {
        _capturedImage = picture; // Store the captured image
      });
      await _cameraController.stopImageStream();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No face detected! Try again.')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
        actions: [
          IconButton(
            icon: Icon(
              cameraDirection == CameraLensDirection.front
                  ? Icons.change_circle
                  : Icons.change_circle_sharp,
            ),
            onPressed: toggleCamera, // Toggle camera on button press
          ),
        ],
      ),
      body: isCameraInitialized
          ? _capturedImage == null
              ? Stack(
                  children: [
                    CameraPreview(_cameraController),

                    // UI Overlay for guiding face positioning
                    Center(
                      child: Container(
                        width: 250,
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Position your face here.',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Capture button
                    faceDetected
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.lightGreen, size: 50),
                                onPressed: captureFace,
                              ),
                            ),
                          )
                        : Container(),
                    // Face detected or not status at the bottom
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: faceDetected
                            ? const Text(
                                'Face detected!',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              )
                            : const Text(
                                'No face detected!',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    // Display the captured image
                    Expanded(
                      child: Image.file(
                        File(
                            _capturedImage!.path), // Preview the captured image
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Retake the picture by resetting the captured image
                              _cameraController
                                  .startImageStream((CameraImage image) {
                                if (!isDetecting) {
                                  isDetecting = true;
                                  detectFace(image);
                                }
                              });
                              setState(() {
                                _capturedImage = null;
                              });
                            },
                            child: const Icon(Icons.close),
                          ),
                          CustomButton(
                              onTap: () async {
                                await _saveImagePath(_capturedImage!.path);
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();

                                final token = pref.getString('token');
                                final idCardFile =
                                    File(pref.getString('front_image_path')!);
                                print(token);
                                print(idCardFile);
                                await uploadIdentityVerification(
                                        idCardFile: idCardFile,
                                        userPicFile: File(_capturedImage!.path),
                                        token: token!)
                                    .then((_) {
                                  widget.onComplete();
                                  Navigator.pushReplacementNamed(
                                      context, BussinessInfo.routeName);
                                });
                              },
                              title: 'Save and continue'),
                        ],
                      ),
                    ),
                  ],
                )
          : const Center(child: NutsActivityIndicator()),
    );
  }
}
