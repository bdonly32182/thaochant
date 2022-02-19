import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickerImage {
  static final ImagePicker _picker = ImagePicker();
  static Future<File?> getImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return File(image!.path);
    } catch (e) {
      return null;
    }
  }

  static Future<File?> takePhoto() async {
    try {
      XFile? takePhoto = await _picker.pickImage(source: ImageSource.camera);
      return File(takePhoto!.path);
    } catch (e) {
      return null;
    }
  }

  static Future<File?> getVideo() async {
    try {
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      return File(video!.path);
    } catch (e) {
      return null;
    }
  }

  static Future<File?> takeVedeo() async {
    try {
      XFile? takeVideo = await _picker.pickVideo(source: ImageSource.camera);
      return File(takeVideo!.path);
    } catch (e) {
      return null;
    }
  }
}
