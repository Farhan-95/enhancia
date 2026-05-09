import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Add Provider
import 'dart:io';

import '../../core/routes/named_routes.dart';
import '../../provider/enhance_provider.dart';
import '../../widgets/custom_loader_widget.dart';

class CaptureImageScreen extends StatefulWidget {
  final String imagePath;

  const CaptureImageScreen({super.key, required this.imagePath});

  @override
  State<CaptureImageScreen> createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {

  Future<void> _enhanceCapturedImage() async {
    final viewModel = context.read<EnhanceProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // 1. Show the Loader
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      builder: (context) => const NonDismissibleApiLoader(),
    );

    // 2. Prepare the File
    File file = File(widget.imagePath);

    // 3. Call ViewModel (This triggers Repository -> API Service)
    await viewModel.processImage(file);

    if (!mounted) return;

    // 4. Close the Loader
    if (navigator.canPop()) navigator.pop();

    // 5. Handle the result based on ViewModel State
    if (viewModel.status == EnhanceStatus.success) {
      // Navigate to Result Screen
      navigator.pushReplacementNamed(
        AppRoutes.result,
        arguments: {
          'original': file,
          'enhanced': viewModel.enhancedFile,
        },
      );
    } else {
      // Show Error from ViewModel
      messenger.showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
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