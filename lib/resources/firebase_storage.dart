import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFirebase {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static void putFileToStorage(String fileName, File file) {
    try {
      _storage.ref().child(fileName).putFile(file);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> showProfileRef(String profileRef) async {
    try {
      String imageURL = await _storage.ref().child(profileRef).getDownloadURL();
      return imageURL;
    } catch (e) {
      return '';
    }
  }

  static Future<String> uploadImage(String fileName, File file) async {
    try {
      UploadTask uploadTask =  _storage.ref().child(fileName).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String dowloadUrl = await snapshot.ref.getDownloadURL();
      return dowloadUrl;
    } catch (e) {
      return '';
    }
  }

  static String getReference(String imageURL) {
    Reference imageRef = _storage.refFromURL(imageURL);
    return imageRef.fullPath;
  }

  static void deleteFile(String profileRef) async {
    try {
      await _storage.ref().child(profileRef).delete();
    } catch (e) {}
  }
}
