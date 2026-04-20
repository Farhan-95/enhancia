import 'package:enhancia/screens/splash/splash_screen.dart';
import 'package:enhancia/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import '../screens/camera/capture_image_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/result/mobile_result_screen.dart';
import '../screens/home/settings.dart';
import 'dart:io';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String capturePreview = '/capture_preview';
  static const String result = '/result';
  static const String setting = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const Splashscreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case camera:
        return MaterialPageRoute(builder: (_) => const CameraScreen());
      case capturePreview:
        final imagePath = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CaptureImageScreen(imagePath: imagePath),
        );
      case setting:
        return MaterialPageRoute(builder: (_) => const Settings());
      case result:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MobileResultScreen(
            originalImage: args['original']!,
            enhancedImage: args['enhanced']!,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}