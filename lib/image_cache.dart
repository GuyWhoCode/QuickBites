import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickbites/env_vars.dart';

class RestaurantImageCache {
  // Define a custom cache manager for Google Places images
  static final customCacheManager = CacheManager(
    Config(
      'googlePlacesImagesCache',
      stalePeriod: const Duration(days: 7), // Cache images for 7 days
      maxNrOfCacheObjects: 100, // Store up to 100 images
      repo: JsonCacheInfoRepository(databaseName: 'restaurantImageCache'),
      fileService: HttpFileService(),
    ),
  );

  // Method to get image from cache or download it
  static Future<File?> getImage(String photoID) async {
    try {
      final photoUrl =
          'https://places.googleapis.com/v1/$photoID/media?key=$GOOGLE_API_KEY&maxHeightPx=800&maxWidthPx=800';

      // Try to get the file from cache first, if not available it will download it
      final fileInfo = await customCacheManager.getSingleFile(photoUrl);
      return fileInfo;
    } catch (e) {
      print('Error getting cached image: $e');
      return null;
    }
  }

  // Method to pre-fetch and cache multiple images at once
  static Future<void> storeImage(String photoID) async {
    try {
      final photoUrl =
          'https://places.googleapis.com/v1/$photoID/media?key=$GOOGLE_API_KEY&maxHeightPx=800&maxWidthPx=800';
      await customCacheManager.getSingleFile(photoUrl);
    } catch (e) {
      print('Error storing image: $e');
    }
  }

  // Method to clear the cache
  static Future<void> clearCache() async {
    await customCacheManager.emptyCache();
  }

  // Get cache size
  static Future<int> getCacheSize() async {
    int totalSize = 0;
    final appDir = await getTemporaryDirectory();
    final cacheDir = Directory('${appDir.path}/googlePlacesImagesCache');

    if (await cacheDir.exists()) {
      await for (final file in cacheDir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
    }

    return totalSize;
  }
}
