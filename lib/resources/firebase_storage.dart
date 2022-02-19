import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFirebase {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static void PutFileToStorage(String fileName, File file) {
    try {
      _storage.ref().child(fileName).putFile(file);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String?> showProfileRef(String profileRef) async {
    try {
      String imageURL = await _storage.ref().child(profileRef).getDownloadURL();
      return imageURL;
    } catch (e) {
      return null;
    }
  }
}
