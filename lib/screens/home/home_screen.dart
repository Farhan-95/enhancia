import 'package:enhancia/screens/home/layouts/desktop_home_screen.dart';
import 'package:enhancia/screens/home/layouts/mobile_home_screen.dart';
import 'package:enhancia/screens/home/layouts/web_home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          return const WebHomeScreen();
        }
        if(constraints.maxWidth < 600){
          return const MobileHomeScreen();
        }
        else {
          return DesktopHomeScreen();
        }
      },
    );
  }
}
