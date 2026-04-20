import 'package:enhancia/routes/named_routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({super.key});

  Future<void> _getStarted(BuildContext context) async {
    await Permission.photos.request();
    await Permission.camera.request();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    Navigator.pushReplacementNamed(
      context, AppRoutes.home
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      padding: EdgeInsets.all(6),
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35,),
          Image.asset('assets/images/welcome2.jpg',),
          SizedBox(height: 20,),
          Text(
            'Take your',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          Text(
            'photos to new',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          Text(
            'heights',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: ElevatedButton.icon(
              onPressed: (){_getStarted(context);},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                fixedSize: Size(300, 55),
              ),
              label: Text(
                'Get Started',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              icon:Icon(Icons.arrow_forward,color: Colors.white,) ,
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    ),
  );
}
}
