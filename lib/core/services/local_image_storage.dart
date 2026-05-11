import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's profile image in the app's permanent documents
/// directory so it survives app restarts (unlike the image picker's temp dir).
class LocalImageStorage {
  static const _key = 'local_profile_image_path';

  /// Copies [sourcePath] (e.g. from image_picker) into the app's documents
  /// directory and saves the permanent path to SharedPreferences.
  /// Returns the permanent path.
  static Future<String> saveImage(String sourcePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final destPath = '${docsDir.path}/profile_image.jpg';

    // Copy to permanent location
    final source = File(sourcePath);
    await source.copy(destPath);

    // Persist the permanent path
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, destPath);

    return destPath;
  }

  /// Returns the saved permanent path, or null if none exists.
  static Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_key);
    if (path == null) return null;
    // Verify the file still exists
    if (!File(path).existsSync()) {
      await prefs.remove(_key);
      return null;
    }
    return path;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_key);
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    }
    await prefs.remove(_key);
  }
}
