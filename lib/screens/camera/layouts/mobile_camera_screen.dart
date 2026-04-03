import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:enhancia/provider/theme_provider.dart';
import 'package:enhancia/screens/camera/capture_image_screen.dart';
import 'package:enhancia/widgets/custom_capture_button.dart';
import 'package:enhancia/widgets/custom_chip.dart';
import '../../../services/camera_service/camera_service.dart';

class MobileCameraScreen extends StatefulWidget {
  const MobileCameraScreen({super.key});

  @override
  State<MobileCameraScreen> createState() => _MobileCameraScreenState();
}

class _MobileCameraScreenState extends State<MobileCameraScreen> {
  final CameraService _cameraService = CameraService();
  bool _isInitialized = false;

  // Zoom & Flash State
  List<int> zoomValueList = [1, 2, 3, 4];
  int onSelected = 1;
  int flashIndex = 0;
  Color switchColor = Colors.white;

  List<IconData> flashIcons = [
    Icons.flash_off_outlined,
    Icons.flash_on_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  void _startUp() async {
    await _cameraService.setupController();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  void _handleCameraSwitch() async {
    setState(() {
      _isInitialized = false;
      switchColor = switchColor == Colors.white ? Colors.red : Colors.white;
    });
    await _cameraService.switchCamera();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _takePicture() async {
    if (!_isInitialized || _cameraService.controller == null) return;
    try {
      XFile file = await _cameraService.controller!.takePicture();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CaptureImageScreen(imagePath: file.path),
        ),
      );
    } catch (e) {
      debugPrint("Error capturing: $e");
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // Dark background for camera feel
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // --- 1. THE CAMERA PREVIEW ---
                  SizedBox(
                    width: double.infinity,
                    child: !_isInitialized
                        ? const Center(child: CircularProgressIndicator())
                        : CameraPreview(_cameraService.controller!),
                  ),

                  // --- 2. TOP ACTIONS (Close & Flash) ---
                  Positioned(
                    top: 15,
                    left: 15,
                    child: buildChip(
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: buildChip(
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            flashIndex = (flashIndex + 1) % flashIcons.length;
                          });
                          // Link to hardware
                          List<FlashMode> modes = [FlashMode.off, FlashMode.always, FlashMode.auto];
                          await _cameraService.setFlash(modes[flashIndex]);
                        },
                        icon: Icon(flashIcons[flashIndex], color: Colors.white),
                      ),
                    ),
                  ),

                  // --- 3. ZOOM BAR ---
                  Positioned(
                    bottom: 120,
                    child: buildChip(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: zoomValueList.map((value) {
                          bool isSelected = onSelected == value;
                          return GestureDetector(
                            onTap: () {
                              setState(() => onSelected = value);
                              _cameraService.setZoom(value.toDouble());
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.black : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  "${value}x",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // --- 4. BOTTOM CONTROLS (Capture & Switch) ---
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 50), // Spacer for balance
                        CustomCaptureButton(onPressed: _takePicture),
                        buildChip(
                          IconButton(
                            onPressed: _handleCameraSwitch,
                            icon: Icon(Icons.cameraswitch_sharp, color: switchColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 5. BOTTOM NAVIGATION LABEL ---
            Consumer<ThemeProvider>(
              builder: (context, provider, child) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: provider.appBarColor,
                  child: Center(
                    child: buildChip(
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'PHOTO',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}