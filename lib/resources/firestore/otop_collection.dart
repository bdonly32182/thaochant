import 'dart:io';
import 'dart:math';

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
  static Future<List<QueryDocumentSnapshot<BusinessModel>>> otops() async {
    List<QueryDocumentSnapshot<BusinessModel>> randomOtops = [];
    List<int> checkList = [];
    QuerySnapshot<BusinessModel> _otops = await otopCollection
        .withConverter<BusinessModel>(
            fromFirestore: (_firestore, _) =>
                BusinessModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    final random = Random();
    int indexRandom = random.nextInt(_otops.docs.length);
    int totalInList = 0;
    int totalInQuery = _otops.docs.length;
    while (totalInList < totalInQuery) {
      if (checkList.contains(indexRandom)) {
        indexRandom = random.nextInt(_otops.docs.length);
      } else {
        checkList.add(indexRandom);
        randomOtops.add(_otops.docs[indexRandom]);
        totalInList = randomOtops.length;
      }
    }
    return randomOtops;
  }

  static Future<List<QueryDocumentSnapshot<BusinessModel>>> searchOtop(
      String search) async {
    QuerySnapshot<BusinessModel> _resultOtop = await otopCollection
        .withConverter<BusinessModel>(
            fromFirestore: (snapshot, _) =>
                BusinessModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    List<QueryDocumentSnapshot<BusinessModel>> searchOtop = _resultOtop.docs
        .where((business) =>
            business.data().businessName.toLowerCase().contains(search))
        .toList();
    return searchOtop;
  }

  static Future<Map<String, dynamic>> createOtop(BusinessModel otop,
      File? imageRef, File? imageQRcode, bool isAdmin) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        otop.imageRef = await StorageFirebase.uploadImage(
            "images/otop/$fileName", imageRef);
      }
      if (imageQRcode != null) {
        String fileName = basename(imageQRcode.path);
        otop.qrcodeRef = await StorageFirebase.uploadImage(
            "images/qrcode/$fileName", imageQRcode);
      }
      DocumentReference _newOtop = await otopCollection.add(otop.toMap());
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

  static Future<DocumentSnapshot<BusinessModel>> otopById(String otopId) async {
    DocumentSnapshot<BusinessModel> _otopDoc = await otopCollection
        .doc(otopId)
        .withConverter<BusinessModel>(
            fromFirestore: (snapshot, _) =>
                BusinessModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _otopDoc;
  }

  static Future<Map<String, dynamic>> editOtop(
    String otopId,
    BusinessModel otop,
    File? imageUpdate,
    File? qrcodeUpdate,
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
      if (qrcodeUpdate != null) {
        if (otop.qrcodeRef.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(otop.qrcodeRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(qrcodeUpdate.path);
        otop.qrcodeRef = await StorageFirebase.uploadImage(
            "images/qrcode/$fileName", qrcodeUpdate);
      }

      await otopCollection.doc(otopId).update(otop.toMap());
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
