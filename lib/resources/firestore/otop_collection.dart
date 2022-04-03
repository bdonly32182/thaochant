import 'dart:io';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference otopCollection =
    _firestore.collection(MyConstant.otopCollection);

class OtopCollection {
  static Future<QuerySnapshot> otops(
      DocumentSnapshot? lastDocument) async {
    if (lastDocument != null) {
      QuerySnapshot _loadMoreOtop = await otopCollection
          .orderBy("statusOpen", descending: true)
          .startAfterDocument(lastDocument)
          .limit(3)
          .get();
      return _loadMoreOtop;
    }
    QuerySnapshot _otops = await otopCollection
        .orderBy("statusOpen", descending: true)
        .limit(3)
        .get();
    return _otops;
  }

  static Future<QuerySnapshot> searchOtop(String search) async {
    QuerySnapshot _resultOtop = await otopCollection
        .orderBy("businessName")
        .startAt([search]).endAt([search + '\uf8ff']).get();
    return _resultOtop;
  }
  static Future<Map<String, dynamic>> createOtop(
      BusinessModel otop, File? imageRef, bool isAdmin) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        otop.imageRef = await StorageFirebase.uploadImage(
            "images/otop/$fileName", imageRef);
      }
      DocumentReference _newOtop = await otopCollection.add({
        "businessName": otop.businessName,
        "sellerId": otop.sellerId,
        "address": otop.address,
        "latitude": otop.latitude,
        "longitude": otop.longitude,
        "statusOpen": otop.statusOpen,
        "policyName": otop.policyName,
        "policyDescription": otop.policyDescription,
        "promptPay": otop.promptPay,
        "phoneNumber": otop.phoneNumber,
        "link": otop.link,
        "imageRef": otop.imageRef,
        "point":otop.point,
        "ratingCount":otop.ratingCount,
      });
      if (isAdmin) {
        NotificationModel _notiModel = NotificationModel(
          message: 'แอดมินสร้างร้านผลิตภัณฑ์ให้เรียบร้อยแล้ว',
          readingStatus: false,
          recipientId: _newOtop.id,
          title: 'แอดมินจัดการร้าน',
        );
        NotificationCollection.createNotification(_notiModel);
      }

      return {"status": "200", "message": "สร้างร้านผลิตภัณฑ์ชุมชนเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างร้านผลิตภัณฑ์ชุมชนล้มเหลว"};
    }
  }

  static Stream<QuerySnapshot<Object?>> myOtops(String sellerId) {
    Stream<QuerySnapshot> _myOtops =
        otopCollection.where('sellerId', isEqualTo: sellerId).snapshots();
    return _myOtops;
  }

  static Future<DocumentSnapshot> otopById(String otopId) async {
    DocumentSnapshot _otopDoc = await otopCollection.doc(otopId).get();
    return _otopDoc;
  }

  static Future<Map<String, dynamic>> editOtop(
    String otopId,
    BusinessModel otop,
    File? imageUpdate,
  ) async {
    try {
      if (imageUpdate != null) {
        if (otop.imageRef.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(otop.imageRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(imageUpdate.path);
        otop.imageRef = await StorageFirebase.uploadImage(
            "images/otop/$fileName", imageUpdate);
      }

      await otopCollection.doc(otopId).update({
        "businessName": otop.businessName,
        "address": otop.address,
        "latitude": otop.latitude,
        "longitude": otop.longitude,
        "statusOpen": otop.statusOpen,
        "policyName": otop.policyName,
        "policyDescription": otop.policyDescription,
        "promptPay": otop.promptPay,
        "phoneNumber": otop.phoneNumber,
        "link": otop.link,
        "imageRef": otop.imageRef,
      });
      return {"status": "200", "message": "แก้ไขข้อมูลร้านผลิตภัณฑ์เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลร้านผลิตภัณฑ์ล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteOtop(
      String docId, String imageRef) async {
    try {
      await otopCollection.doc(docId).delete();
      QuerySnapshot _products =
          await ProductOtopCollection.productsInOtop(docId);
      for (QueryDocumentSnapshot product in _products.docs) {
        await ProductOtopCollection.deleteProduct(
            product.id, product.get('imageRef'));
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

  static Future<void> setPointOtop(String docId, num point) async {
    try {
      otopCollection.doc(docId).update({
        "point": FieldValue.increment(point),
        "ratingCount": FieldValue.increment(1),
      });
    } catch (e) {}
  } 

  static Future<void> changeStatus(String docId, int status) async {
    try {
      await otopCollection.doc(docId).update({"statusOpen": status});
    } catch (e) {}
  }
}
