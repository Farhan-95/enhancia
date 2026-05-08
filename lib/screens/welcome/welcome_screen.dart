import 'package:enhancia/screens/welcome/layouts/desktop_welcome_screen.dart';
import 'package:enhancia/screens/welcome/layouts/mobile_welcome_screen.dart';
import 'package:flutter/cupertino.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const MobileWelcomeScreen();
        } else {
          return const DesktopWelcomeScreen();
        }
      },
    );
  }
}
