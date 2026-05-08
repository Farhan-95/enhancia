import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String baseUrl = "https://hippest-genia-sneerful.ngrok-free.dev";
  static http.Client? _activeClient;

  // ✅ PLACE IT HERE: This fixes the 'Member not found' error
  static void cancelRequest() {
    _activeClient?.close();
    _activeClient = null;
    if (kDebugMode) {
      print("🚫 Request manually cancelled.");
    }
  }

  static Future<File?> enhanceImage(File imageFile) async {
    _activeClient = http.Client();
    try {
      var uri = Uri.parse("$baseUrl/enhance");
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        "ngrok-skip-browser-warning": "69420",
        "Accept": "image/jpeg",
      });

      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Increase timeout slightly for very high-res images
      var streamedResponse = await _activeClient!.send(request).timeout(const Duration(minutes: 12));

      if (kDebugMode) {
        print("📡 Response Code: ${streamedResponse.statusCode}");
      }

      if (streamedResponse.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final tempFile = File('${tempDir.path}/$fileName');

        final IOSink sink = tempFile.openWrite();

        // This pipes the data directly to the storage
        await streamedResponse.stream.pipe(sink);
        await sink.close();

        // Safety check: ensure file isn't empty
        if (await tempFile.length() > 0) {
          return tempFile;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ API Error: $e");
      }
      return null;
    } finally {
      _activeClient = null;
    }
  }
}