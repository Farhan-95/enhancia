import 'package:enhancia/services/api%20service/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer
import 'package:google_fonts/google_fonts.dart';

class NonDismissibleApiLoader extends StatefulWidget {
  const NonDismissibleApiLoader({super.key});

  @override
  State<NonDismissibleApiLoader> createState() => _NonDismissibleApiLoaderState();
}

class _NonDismissibleApiLoaderState extends State<NonDismissibleApiLoader> {
  // Timer and current text management
  Timer? _statusTimer;
  int _currentTextIndex = 0;

  // The sequential messages for the FYP pipeline
  final List<String> _statusTexts = [
    "Image is upscaling...",      // Step 1: Real-ESRGAN
    "Restoring the face...",       // Step 2: GFPGAN
    "Upgrading image quality...",  // Step 3: Sharpness & Color
  ];

  @override
  void initState() {
    super.initState();
    // Start the automatic text switcher when the widget appears
    _startTextRotation();
  }

  @override
  void dispose() {
    // Crucial: Stop the timer if the widget is removed
    _statusTimer?.cancel();
    super.dispose();
  }

  // The logic that changes the text every 10 seconds
  void _startTextRotation() {
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          // Increment the index, but restart from 0 if we hit the end
          _currentTextIndex = (_currentTextIndex + 1) % _statusTexts.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        // Prevent accidental closing with the physical Back button
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return; // Already going back, ignore
          ApiService.cancelRequest(); // NEW: Still cancel if they spam back button
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. YOUR CUSTOM LOGO (ASSET)
              Center(
                child: Container(
                  height: 200, // Adjust size as needed
                  width: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      // Ensure the file exists in this path
                      image: AssetImage('assets/icons/enhancia_loading.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 2. NATIVE SPINNER (Re-adding it so they know it's working)
              // const CircularProgressIndicator(color: Colors.red),
              // const SizedBox(height: 30),

              // 3. THE CONTEXT-AWARE TEXT (DYNAMIC)
              Text(
                _statusTexts[_currentTextIndex], // Display current message
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),

              // 4. SUBTEXT (To reassure the user)
              Text(
                "Final Year Project Pipeline. Please wait.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}