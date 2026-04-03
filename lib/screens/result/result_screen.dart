import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'layouts/desktop_result_screen.dart';
import 'layouts/web_result_screen.dart';

class MobileResultScreen extends StatelessWidget {
  const MobileResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(kIsWeb){
        return const WebResultScreen();
      }
      else if(constraints.maxWidth<600){
        return const MobileResultScreen();
      }
      else{
        return DesktopResultScreen();
      }
    });
  }
}
