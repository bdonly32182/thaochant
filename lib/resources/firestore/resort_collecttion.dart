import 'dart:io';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _resort =
    _firestore.collection(MyConstant.resortCollection);

class ResortCollection {
  static Future<Map<String, dynamic>> createResort(
      BusinessModel resort, File? imageRef, bool isAdmin) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        resort.imageRef = await StorageFirebase.uploadImage(
            "images/restaurant/$fileName", imageRef);
      }
      DocumentReference _newResort = await _resort.add({
        "businessName": resort.businessName,
        "sellerId": resort.sellerId,
        "address": resort.address,
        "latitude": resort.latitude,
        "longitude": resort.longitude,
        "statusOpen": resort.statusOpen,
        "policyName": resort.policyName,
        "policyDescription": resort.policyDescription,
        "promptPay": resort.promptPay,
        "phoneNumber": resort.phoneNumber,
        "link": resort.link,
        "imageRef": resort.imageRef,
        "point":resort.point,
        "ratingCount":resort.ratingCount,
      });
      if (isAdmin) {
        NotificationModel _notiModel = NotificationModel(
          message: 'แอดมินสร้างบ้านพักให้เรียบร้อยแล้ว',
          readingStatus: false,
          recipientId: _newResort.id,
          title: 'แอดมินจัดการบ้านพัก',
        );
        NotificationCollection.createNotification(_notiModel);
      }
      return {"status": "200", "message": "สร้างบ้านพักเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างบ้านพักล้มเหลว"};
    }
  }

  static Stream<QuerySnapshot<Object?>> myResorts(String sellerId) {
    Stream<QuerySnapshot> _myResorts =
        _resort.where('sellerId', isEqualTo: sellerId).snapshots();
    return _myResorts;
  }

  static Future<DocumentSnapshot> resortById(String resortId) async {
    DocumentSnapshot _resortDoc = await _resort.doc(resortId).get();
    return _resortDoc;
  }

  static Future<Map<String, dynamic>> editResort(
    String resortId,
    BusinessModel resort,
    File? imageUpdate,
  ) async {
    try {
      if (imageUpdate != null) {
        if (resort.imageRef.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(resort.imageRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(imageUpdate.path);
        resort.imageRef = await StorageFirebase.uploadImage(
            "images/resort/$fileName", imageUpdate);
      }

      await _resort.doc(resortId).update({
        "businessName": resort.businessName,
        "address": resort.address,
        "latitude": resort.latitude,
        "longitude": resort.longitude,
        "statusOpen": resort.statusOpen,
        "policyName": resort.policyName,
        "policyDescription": resort.policyDescription,
        "promptPay": resort.promptPay,
        "phoneNumber": resort.phoneNumber,
        "link": resort.link,
        "imageRef": resort.imageRef,
      });

      return {"status": "200", "message": "แก้ไขข้อมูลห้องพักเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลห้องพักล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteResort(
      String docId, String imageRef) async {
    try {
      await _resort.doc(docId).delete();
      QuerySnapshot _rooms = await RoomCollection.deleteRoomInResort(docId);
      for (QueryDocumentSnapshot room in _rooms.docs) {
        await RoomCollection.deleteRoom(
            room.id, room.get('imageCover'), room.get('listImageDetail'));
      }
      if (imageRef.isNotEmpty) {
        String referenceImage = StorageFirebase.getReference(imageRef);
        StorageFirebase.deleteFile(referenceImage);
      }
      return {"status": "200", "message": "ลบข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<void> changeStatus(String docId, int status) async {
    try {
      await _resort.doc(docId).update({"statusOpen": status});
    } catch (e) {}
  }
}
