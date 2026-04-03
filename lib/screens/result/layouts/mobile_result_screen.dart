import 'dart:io';
import 'package:enhancia/screens/home/layouts/mobile_home_screen.dart';
import 'package:enhancia/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:before_after/before_after.dart';
import 'package:enhancia/widgets/custom_chip.dart';

class MobileResultScreen extends StatefulWidget {
  final File originalImage;
  final File enhancedImage;

  const MobileResultScreen({
    super.key,
    required this.originalImage,
    required this.enhancedImage,
  });

  @override
  State<MobileResultScreen> createState() => _MobileResultScreenState();
}

class _MobileResultScreenState extends State<MobileResultScreen> {
  double slideValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        centerTitle: true,
        title: Text(
          'Result',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        showBackButton: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "You haven't saved the photo yet.",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 10),

                    // Exit Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MobileHomeScreen(),
                          ),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        fixedSize: const Size(250, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Yes, Exit'),
                    ),

                    const SizedBox(height: 10),

                    // Save Button
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Save image to gallery
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(230, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      child: const Text(
                        'Save Photo',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // TODO: Download functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Image.asset('assets/icons/download_icon.png', height: 25),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 7),

          Expanded(
            child: Stack(
              children: [
                // 🔥 Before/After Comparison
                BeforeAfter(
                  value: slideValue,
                  onValueChanged: (val) => setState(() => slideValue = val),
                  width: double.infinity,
                  height: double.infinity,
                  direction: SliderDirection.horizontal,

                  // ✅ BEFORE IMAGE
                  before: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      widget.originalImage,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ✅ AFTER IMAGE
                  after: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      widget.enhancedImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // BEFORE Label
                Positioned(
                  top: 20,
                  left: 20,
                  child: buildChip(
                    Text(
                      'Before',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // AFTER Label
                Positioned(
                  top: 20,
                  right: 20,
                  child: buildChip(
                    Text(
                      'After',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}