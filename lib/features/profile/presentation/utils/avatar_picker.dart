import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AvatarPicker {
  AvatarPicker._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    final XFile? xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xfile == null) return null;
    return File(xfile.path);
  }

  static Future<File?> pickFromCamera() async {
    final XFile? xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.front,
    );
    if (xfile == null) return null;
    return File(xfile.path);
  }
}
