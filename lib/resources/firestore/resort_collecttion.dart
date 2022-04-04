import 'dart:io';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/models/resort/room.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _resort =
    _firestore.collection(MyConstant.resortCollection);

class ResortCollection {
  static Future<Map<String, dynamic>> createResort(BusinessModel resort,
      File? imageRef, File? imageQRcode, bool isAdmin) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        resort.imageRef = await StorageFirebase.uploadImage(
            "images/resort/$fileName", imageRef);
      }
      if (imageQRcode != null) {
        String fileName = basename(imageQRcode.path);
        resort.qrcodeRef = await StorageFirebase.uploadImage(
            "images/qrcode/$fileName", imageQRcode);
      }
      DocumentReference _newResort = await _resort.add(resort.toMap());
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

  static Future<QuerySnapshot<BusinessModel>> allResort(
      DocumentSnapshot? lastDocument) async {
    if (lastDocument != null) {
      QuerySnapshot<BusinessModel> _lastResorts = await _resort
          .withConverter<BusinessModel>(
            fromFirestore: (snapshot, _) =>
                BusinessModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap(),
          )
          .limit(10)
          .get();
      return _lastResorts;
    }
    QuerySnapshot<BusinessModel> _allResorts = await _resort
        .withConverter<BusinessModel>(
          fromFirestore: (snapshot, _) =>
              BusinessModel.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        )
        .limit(10)
        .get();
    return _allResorts;
  }

  static Future<List<QueryDocumentSnapshot<BusinessModel>>> resortReadyCheckIn(
      int totalRoom, totalGues, checkIn, checkOut) async {
    List<QueryDocumentSnapshot<BusinessModel>> resorts = [];
    QuerySnapshot<BusinessModel> _resortSnapshot = await _resort
        .withConverter<BusinessModel>(
          fromFirestore: (snapshot, _) =>
              BusinessModel.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        )
        .get();
    for (QueryDocumentSnapshot<BusinessModel> resort in _resortSnapshot.docs) {
      QuerySnapshot<RoomModel> room =
          await RoomCollection.roomsByUser(resort.id);
      if (room.docs.isNotEmpty) {
        QuerySnapshot bookings = await BookingCollection.bookingOfRoom(
            room.docs[0].id, checkIn, checkOut);
        if (bookings.docs.length < room.docs[0].data().totalRoom) {
          resorts.add(resort);
        }
      }
    }
    return resorts;
  }

  static Future<DocumentSnapshot<BusinessModel>> resortById(
      String resortId) async {
    DocumentSnapshot<BusinessModel> _resortDoc = await _resort
        .doc(resortId)
        .withConverter<BusinessModel>(
            fromFirestore: (snapshot, _) =>
                BusinessModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _resortDoc;
  }

  static Future<void> setPointResort(String docId, num point) async {
    try {
      _resort.doc(docId).update({
        "point": FieldValue.increment(point),
        "ratingCount": FieldValue.increment(1),
      });
    } catch (e) {}
  }

  static Future<Map<String, dynamic>> editResort(
    String resortId,
    BusinessModel resort,
    File? imageUpdate,
    File? qrcodeUpdate,
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
      if (qrcodeUpdate != null) {
        if (resort.qrcodeRef.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(resort.qrcodeRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(qrcodeUpdate.path);
        resort.qrcodeRef = await StorageFirebase.uploadImage(
            "images/qrcode/$fileName", qrcodeUpdate);
      }

      await _resort.doc(resortId).update(resort.toMap());

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
