import 'dart:io';

import 'package:chanthaburi_app/models/booking/booking_tour.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference orderTourCollection =
    _firestore.collection(MyConstant.orderTourCollection);

class OrderTourCollection {
  static Stream<QuerySnapshot<BookingTourModel>> orderByUserId(String userId) {
    Stream<QuerySnapshot<BookingTourModel>> _order = orderTourCollection
        .where("userId", isEqualTo: userId)
        .orderBy("dateCreate",descending: true)
        .limit(10)
        .withConverter<BookingTourModel>(
            fromFirestore: (snapshot, _) =>
                BookingTourModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _order;
  }

  static Stream<QuerySnapshot<BookingTourModel>> orderByAddmin(
      List<String> status, int orderDate, int endOrderDate) {
    Stream<QuerySnapshot<BookingTourModel>> _orders = orderTourCollection
        .where("status", whereIn: status)
        .orderBy("dateCreate")
        .startAt([orderDate])
        .endAt([endOrderDate])
        .withConverter<BookingTourModel>(
            fromFirestore: (snapshot, _) =>
                BookingTourModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _orders;
  }

  static Future<Map<String, dynamic>> createOrder(
      BookingTourModel order, File imagePayment) async {
    try {
      String fileName = basename(imagePayment.path);
      order.imagePayment = await StorageFirebase.uploadImage(
          "images/order/$fileName", imagePayment);
      await orderTourCollection.add(order.toMap());
      return {"status": "200", "message": "ยืนยันการสั่งซื้อเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ยืนยันการสั่งซื้อล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> changeStatus(
      String orderId, status, recipientId) async {
    try {
      String statusText = MyConstant.statusColor[status]!["text"];
      await orderTourCollection.doc(orderId).update({"status": status});
      NotificationModel noti = NotificationModel(
        message: "ออร์เดอร์การสั่งซื้อของคุณถูกเปลี่ยนสถานะเป็น $statusText เรียบร้อยแล้ว",
        readingStatus: false,
        recipientId: recipientId,
        title: "การตอบรับการเข้าร่วมทริป",
      );
      await NotificationCollection.createNotification(noti);
      return {"status": "200", "message": "เปลี่ยนสถานะเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "เปลี่ยนสถานะล้มเหลว"};
    }
  }

  static Future<void> updateReview(String docId) async {
    await orderTourCollection.doc(docId).update({
      "reviewed": true,
    });
  }
}
