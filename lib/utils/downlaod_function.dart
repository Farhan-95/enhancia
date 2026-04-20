import 'dart:io';
import 'dart:typed_data';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

// Function to handle the download
Future<void> saveEnhancedImage(
  BuildContext context,
  Uint8List imageBytes,
) async {
  try {
    // 1. Get temporary path to store the bytes before moving to Gallery
    final tempDir = await getTemporaryDirectory();
    final path =
        '${tempDir.path}/enhancia_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // 2. Write the bytes to a file
    File(path).writeAsBytesSync(imageBytes);

    // 3. Save to Gallery
    await Gal.putImage(path, album: 'Enhancia AI');

    // 4. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '✅ Saved to Gallery!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Error: $e', style: TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}
