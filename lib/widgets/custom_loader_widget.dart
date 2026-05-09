import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/enhance_provider.dart';

class NonDismissibleApiLoader extends StatefulWidget {
  const NonDismissibleApiLoader({super.key});

  @override
  State<NonDismissibleApiLoader> createState() => _NonDismissibleApiLoaderState();
}

class _NonDismissibleApiLoaderState extends State<NonDismissibleApiLoader> {
  Timer? _statusTimer;
  int _currentTextIndex = 0;

  final List<String> _statusTexts = [
    "Image is upscaling...",
    "Restoring the face...",
    "Upgrading image quality...",
  ];

  @override
  void initState() {
    super.initState();
    _startTextRotation();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void _startTextRotation() {
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _statusTexts.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the viewmodel to handle cancellation
    final viewModel = context.read<EnhanceProvider>();

    return Scaffold(
      backgroundColor: Colors.black, // Ensure background is dark for premium look
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          // logic: Tell ViewModel to cancel, which tells Repo, which tells API
          viewModel.cancelEnhancement();

          // Close the dialog manually since canPop is false
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/icons/enhancia_loading.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Added a linear progress indicator for better UX
              const LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white24,
              ),
              const SizedBox(height: 20),

              Text(
                _statusTexts[_currentTextIndex],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),

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