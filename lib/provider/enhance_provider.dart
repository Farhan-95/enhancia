import 'dart:io';
import 'package:flutter/material.dart';
import '../data/repository/enhancia_repository.dart';
import '../core/data_state.dart';

enum EnhanceStatus { idle, loading, success, error }

class EnhanceProvider extends ChangeNotifier {
  final EnhanciaRepository _repository = EnhanciaRepository();

  EnhanceStatus _status = EnhanceStatus.idle;
  String _errorMessage = "";
  File? _enhancedFile;

  EnhanceStatus get status => _status;
  String get errorMessage => _errorMessage;
  File? get enhancedFile => _enhancedFile;

  Future<void> processImage(File file) async {
    _status = EnhanceStatus.loading;
    notifyListeners();

    final result = await _repository.getEnhancedImage(file);

    if (result is DataSuccess) {
      _enhancedFile = result.data;
      _status = EnhanceStatus.success;
    } else {
      _errorMessage = result.message ?? "An error occurred";
      _status = EnhanceStatus.error;
    }
    notifyListeners();
  }

  void resetState() {
    _status = EnhanceStatus.idle;
    _errorMessage = "";
    _enhancedFile = null;
  }

  void cancelEnhancement() {
    _repository.cancelTask(); // Pass the command to the repo
    _status = EnhanceStatus.idle;
    notifyListeners();
  }
}