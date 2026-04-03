import 'package:enhancia/screens/camera/layouts/desktop_camera_screen.dart';
import 'package:enhancia/screens/camera/layouts/mobile_camera_screen.dart';
import 'package:enhancia/screens/camera/layouts/web_camera_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          return const WebCameraScreen();
        } else if (constraints.maxWidth < 600) {
          return const MobileCameraScreen();
        } else {
          return const DesktopCameraScreen();
        }
      },
    );
  }
}
