import 'dart:io';
import '../../core/data_state.dart';
import '../services/api service/api_service.dart';

class EnhanciaRepository {
  Future<DataState<File>> getEnhancedImage(File originalFile) async {
    try {
      final result = await ApiService.enhanceImage(originalFile);
      if (result != null) {
        return DataSuccess(result);
      } else {
        return const DataFailed("Failed to process image. Try again.");
      }
    } on SocketException {
      return const DataFailed("No internet connection.");
    } on HttpException {
      return const DataFailed("Server could not be reached.");
    } catch (e) {
      return DataFailed("Error: ${e.toString()}");
    }
  }

  void cancelTask() {
    ApiService.cancelRequest();
  }
}