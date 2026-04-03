import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.16:5051"; // your backend IP

  static Future<File?> enhanceImage(File imageFile) async {
    try {
      var uri = Uri.parse("$baseUrl/enhance");
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        // get bytes
        Uint8List bytes = await response.stream.toBytes();

        // save bytes to temp file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/enhanced_${basename(imageFile.path)}');
        await tempFile.writeAsBytes(bytes);

        return tempFile; // now a File, not Uint8List
      } else {
        print("Failed to enhance image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error in enhanceImage: $e");
      return null;
    }
  }
}