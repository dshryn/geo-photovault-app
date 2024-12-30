import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> saveImageToStorage(
      File imageFile, String cityName) async {
    try {
      final Directory? appDir = await getExternalStorageDirectory();

      if (appDir == null) {
        throw Exception("Unable to access external storage directory.");
      }

      // make city folder
      final Directory cityDir = Directory('${appDir.path}/$cityName');
      if (!cityDir.existsSync()) {
        cityDir.createSync(recursive: true);
      }

      // maek file name
      final String fileName =
          'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // save
      final File newFile = File('${cityDir.path}/$fileName');
      final File savedFile = await imageFile.copy(newFile.path);

      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }
}
