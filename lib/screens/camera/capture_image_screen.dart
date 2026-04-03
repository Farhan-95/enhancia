import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class CaptureImageScreen extends StatelessWidget {
  final String imagePath;

  const CaptureImageScreen({super.key,required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text(
          'Capture Image',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        showBackButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close,color: Colors.white,),
        ),
        actions: [ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Icon(Icons.done,color: Colors.black,),)],
      ),
      body: SizedBox.expand(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain, // Ensures the whole photo is visible
        ),
      ),
    );
  }
}
