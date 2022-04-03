import 'dart:io';

import 'package:chanthaburi_app/models/booking/booking.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference bookingCollection =
    _firestore.collection(MyConstant.bookingCollection);

class BookingCollection {
  static Future<Map<String, dynamic>> createBooking(
      BookingModel booking, File imagePayment) async {
    try {
      String fileName = basename(imagePayment.path);
      booking.imagePayment = await StorageFirebase.uploadImage(
          "images/booking/$fileName", imagePayment);
      await bookingCollection.add(booking.toMap());
      return {"status": "200", "message": "ยืนยันการชำระเงินเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ยืนยันการชำระเงินล้มเหลว"};
    }
  }

  static Future<QuerySnapshot> bookingOfRoom(
      String roomId, int checkIn, int checkOut) async {
    QuerySnapshot bookings = await bookingCollection
        .where("roomId", isEqualTo: roomId)
        .orderBy("checkIn")
        .startAt([checkIn]).endAt([checkOut]).get();
    return bookings;
  }

  static Stream<QuerySnapshot<BookingModel>> bookingByUserId(
      String userId, List<String> status) {
    Stream<QuerySnapshot<BookingModel>> bookingUser = bookingCollection
        .where("userId", isEqualTo: userId)
        .orderBy("dateCreate",descending: true)
        .withConverter<BookingModel>(
            fromFirestore: (snapshot, _) =>
                BookingModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return bookingUser;
  }

  static Stream<QuerySnapshot<BookingModel>> orderByResort(
      String resortId,
      List<String> status,
      int orderStart,
      int endOrderDate) {
    Stream<QuerySnapshot<BookingModel>> _orders = bookingCollection
        .where("resortId", isEqualTo: resortId)
        .where("status", whereIn: status)
        .orderBy("dateCreate")
        .startAt([orderStart])
        .endAt([endOrderDate])
        .withConverter<BookingModel>(
            fromFirestore: (snapshot, _) =>
                BookingModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _orders;
  }

  static Future<Map<String, dynamic>> changeStatus(
      String orderId, status, recipientId) async {
    try {
      String statusText = MyConstant.statusColor[status]!["text"];
      await bookingCollection.doc(orderId).update({"status": status});
      NotificationModel noti = NotificationModel(
        message: "ออร์เดอร์การจองของคุณถูก $statusText เรียบร้อยแล้ว",
        readingStatus: false,
        recipientId: recipientId,
        title: "การตอบรับของรีสอร์ท",
      );
      await NotificationCollection.createNotification(noti);
      return {"status": "200", "message": "เปลี่ยนสถานะเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "เปลี่ยนสถานะล้มเหลว"};
    }
  }

  static Future<QuerySnapshot> checkBookingUser(
      String userId, int checkIn, int checkOut) async {
    QuerySnapshot bookingUser = await bookingCollection
        .where("userId", isEqualTo: userId)
        .orderBy("checkIn")
        .startAt([checkIn]).endAt([checkOut]).get();
    return bookingUser;
  }

  static Future<void> updateReview(String docId) async {
    await bookingCollection.doc(docId).update({
      "reviewed": true,
    });
  }
}
