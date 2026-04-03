import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryProvider extends ChangeNotifier {
  List<AssetEntity> images = [];
  bool isLoading = false;

  // Load all images from gallery
  Future<void> loadImages() async {
    isLoading = true;
    notifyListeners();

    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: false,
      );

      List<AssetEntity> allImages = [];

      for (var album in albums) {
        int page = 0;
        int pageSize = 100;
        List<AssetEntity> assets;

        do {
          assets = await album.getAssetListPaged(
            page: page,
            size: pageSize,
          );

          allImages.addAll(assets);
          page++;
        } while (assets.isNotEmpty);
      }

      // Sort latest images first
      allImages.sort(
            (a, b) => b.createDateTime.compareTo(a.createDateTime),
      );

      images = allImages;
    } catch (e) {
      debugPrint("Error loading images: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Convert AssetEntity to File (used for backend upload)
  Future<File?> getFile(AssetEntity asset) async {
    try {
      return await asset.file;
    } catch (e) {
      debugPrint("Error getting file: $e");
      return null;
    }
  }
}