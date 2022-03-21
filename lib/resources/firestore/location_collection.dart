import 'dart:io';

import 'package:chanthaburi_app/models/location/location.dart';
import 'package:chanthaburi_app/resources/firestore/review_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../firebase_storage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference locationCollection =
    _firestore.collection(MyConstant.locationCollection);

class LocationCollection {
  static Stream<QuerySnapshot> locations() {
    Stream<QuerySnapshot> _locations =
        locationCollection.orderBy('point').snapshots();
    return _locations;
  }

  static Future<DocumentSnapshot> location(String docId) async {
    DocumentSnapshot _location = await locationCollection.doc(docId).get();
    return _location;
  }

  static Future<Map<String, dynamic>> createLocation(
      LocationModel location, List<File>? listImageFile, File? videoRef) async {
    try {
      if (listImageFile != null) {
        for (File file in listImageFile) {
          String fileName = basename(file.path);
          String imageUrl = await StorageFirebase.uploadImage(
              "images/location/$fileName", file);
          location.imageList.add(imageUrl);
        }
      }
      if (videoRef != null) {
        String fileName = basename(videoRef.path);
        String videoURL = await StorageFirebase.uploadImage(
            "video/location/$fileName", videoRef);
        location.videoRef = videoURL;
      }
      await locationCollection.add({
        "address": location.address,
        "imageList": location.imageList,
        "locationName": location.locationName,
        "point": location.point,
        "ratingCount": location.ratingCount,
        "videoRef": location.videoRef,
        "description": location.description,
        "lat": location.lat,
        "lng": location.lng,
      });
      return {"status": "200", "message": "สร้างแหล่งท่องเที่ยวเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างแหล่งท่องเที่ยวล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editLocation(
      LocationModel location,
      List<File>? listImageFileAdd,
      List<String> listImageDelete,
      File? videoRef,
      String docId) async {
    try {
      if (listImageFileAdd != null) {
        for (File file in listImageFileAdd) {
          String fileName = basename(file.path);
          String imageUrl = await StorageFirebase.uploadImage(
              "images/location/$fileName", file);
          location.imageList.add(imageUrl);
        }
      }
      if (videoRef != null) {
        if (location.videoRef.isNotEmpty) {
          String videoRefStorage =
              StorageFirebase.getReference(location.videoRef);
          StorageFirebase.deleteFile(videoRefStorage);
        }
        String fileName = basename(videoRef.path);
        String videoURL = await StorageFirebase.uploadImage(
            "video/location/$fileName", videoRef);
        location.videoRef = videoURL;
      }
      if (listImageDelete.isNotEmpty) {
        for (String url in listImageDelete) {
          String imageURL = StorageFirebase.getReference(url);
          StorageFirebase.deleteFile(imageURL);
        }
      }
      await locationCollection.doc(docId).update({
        "address": location.address,
        "imageList": location.imageList,
        "locationName": location.locationName,
        "point": location.point,
        "ratingCount": location.ratingCount,
        "videoRef": location.videoRef,
        "description": location.description,
        "lat": location.lat,
        "lng": location.lng,
      });
      return {"status": "200", "message": "แก้ไขแหล่งท่องเที่ยวเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขแหล่งท่องเที่ยวล้มเหลว"};
    }
  }

  static Future<void> setPointLocation(String docId, num point) async {
    try {
      locationCollection.doc(docId).update({
        "point": FieldValue.increment(point),
        "ratingCount": FieldValue.increment(1),
      });
    } catch (e) {}
  }

  static Future<Map<String, dynamic>> deleteLocation(
      String docId, List<String> imageList, String videoRef) async {
    try {
      if (imageList.isNotEmpty) {
        for (String url in imageList) {
          String imageURL = StorageFirebase.getReference(url);
          StorageFirebase.deleteFile(imageURL);
        }
      }
      if (videoRef.isNotEmpty) {
        String videoURL = StorageFirebase.getReference(videoRef);
        StorageFirebase.deleteFile(videoURL);
      }
      await locationCollection.doc(docId).delete();
      await ReviewCollection.deleteReview(docId);
      
      return {"status": "200", "message": "ลบแหล่งท่องเที่ยวเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบแหล่งท่องเที่ยวเรียบร้อย"};
    }
  }
}
