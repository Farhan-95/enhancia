import 'package:enhancia/screens/home/home_screen.dart';
import 'package:enhancia/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    moveNext();
  }

  void moveNext() async {
    await Future.delayed(Duration(seconds: 5));
    
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime')??true;
     if(isFirstTime){
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => WelcomeScreen()),
       );
     }
     else{
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => HomeScreen()),
       );
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 170),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/icons/black_logo.png',
                height: 270,
                width: 270,
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Enhancia',
            style: GoogleFonts.poppins(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Bring Every Details to Life',
            style: GoogleFonts.inter(
              fontSize: 23,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 100),
          Image.asset('assets/icons/loadingIcon.gif', height: 60, width: 60),
        ],
      ),
    );
  }
}
