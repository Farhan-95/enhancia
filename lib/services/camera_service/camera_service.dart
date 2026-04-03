import 'package:camera/camera.dart';

class CameraService {
  CameraController? controller;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;

  // Initialize the list of cameras
  Future<void> initCameras() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
  }

  // Setup the controller for a specific index
  Future<CameraController?> setupController() async {
    await initCameras();

    // Dispose old one if switching
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await controller!.initialize();
    return controller;
  }

  // Toggle index and return new controller
  Future<CameraController?> switchCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    return await setupController();
  }

  // Zoom Logic
  Future<void> setZoom(double level) async {
    await controller?.setZoomLevel(level);
  }

  // Flash Logic
  Future<void> setFlash(FlashMode mode) async {
    await controller?.setFlashMode(mode);
  }

  // Clean up
  void dispose() {
    controller?.dispose();
  }
}