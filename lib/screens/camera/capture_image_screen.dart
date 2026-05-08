import 'package:enhancia/services/api%20service/api_service.dart';
import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import '../../routes/named_routes.dart';
import '../../widgets/custom_loader_widget.dart';

class CaptureImageScreen extends StatefulWidget {
  final String imagePath;

  const CaptureImageScreen({super.key, required this.imagePath});

  @override
  State<CaptureImageScreen> createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {

  Future<void> _enhanceCapturedImage() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // 1. SHOW CUSTOM LOADING SCREEN
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black, // Makes it look premium
      builder: (context) => const NonDismissibleApiLoader(),
    );

    try {
      File file = File(widget.imagePath);

      // 2. CALL API
      final enhancedFile = await ApiService.enhanceImage(file);

      if (!mounted) return;

      // 3. CLOSE LOADING SCREEN
      if (navigator.canPop()) navigator.pop();

      if (enhancedFile != null) {
        // 4. NAVIGATE TO RESULT
        Navigator.pushReplacementNamed(context, AppRoutes.result,arguments: {
          'original': file,
          'enhanced': enhancedFile,
        },);
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text("Enhancement failed. Please try again.")),
        );
      }
    } catch (e) {
      if (navigator.canPop()) navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _enhanceCapturedImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(50, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Icon(Icons.done, color: Colors.black),
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Image.file(
          File(widget.imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}