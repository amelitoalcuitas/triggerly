import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageStorage {
  static final ImageStorage instance = ImageStorage._init();
  static const String _imagesFolder = 'meal_images';

  ImageStorage._init();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _imagesDirectory async {
    final path = await _localPath;
    final imagesPath = join(path, _imagesFolder);
    return Directory(imagesPath).create(recursive: true);
  }

  Future<String> saveImage(File imageFile) async {
    final imagesDir = await _imagesDirectory;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'meal_$timestamp.jpg';
    final newPath = join(imagesDir.path, fileName);

    // Copy the file to the new location
    await imageFile.copy(newPath);
    return newPath;
  }

  Future<File?> getImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<void> deleteImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
