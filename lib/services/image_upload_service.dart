import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('$path/$fileName');
      return savedImage.path;
    }
    return null;
  }
  
  getApplicationDocumentsDirectory() {}
}
