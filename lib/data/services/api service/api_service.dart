import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String baseUrl = "https://hippest-genia-sneerful.ngrok-free.dev";
  static http.Client? _activeClient;

  static void cancelRequest() {
    _activeClient?.close();
    _activeClient = null;
  }

  static Future<File?> enhanceImage(File imageFile) async {
    _activeClient = http.Client();
    var uri = Uri.parse("$baseUrl/enhance");
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "ngrok-skip-browser-warning": "69420",
      "Accept": "image/jpeg",
    });

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var streamedResponse = await _activeClient!.send(request).timeout(const Duration(minutes: 12));

    if (streamedResponse.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File('${tempDir.path}/$fileName');

      final IOSink sink = tempFile.openWrite();
      await streamedResponse.stream.pipe(sink);
      await sink.close();

      return (await tempFile.length() > 0) ? tempFile : null;
    } else {
      throw Exception("Server Error: ${streamedResponse.statusCode}");
    }
  }
}