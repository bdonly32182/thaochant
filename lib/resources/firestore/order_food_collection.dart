import 'dart:io';

import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/models/order/order.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference orderFoodCollection =
    _firestore.collection(MyConstant.orderFoodCollection);

class OrderFoodCollection {
  static Stream<QuerySnapshot<OrderModel>> orderByUserId(String userId) {
    Stream<QuerySnapshot<OrderModel>> _order = orderFoodCollection
        .where("userId", isEqualTo: userId)
        .orderBy("dateCreate", descending: true)
        .limit(10)
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _order;
  }

  static Stream<QuerySnapshot<OrderModel>> orderByRestaurantId(
      String restaurantId,
      List<String> status,
      int orderStart,
      int endOrderDate) {
    Stream<QuerySnapshot<OrderModel>> _orders = orderFoodCollection
        .where("businessId", isEqualTo: restaurantId)
        .where("status", whereIn: status)
        .orderBy("dateCreate")
        .startAt([orderStart])
        .endAt([endOrderDate])
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _orders;
  }

  static Future<int> ordersOfMonth(
    String restaurantId,
    List<String> status,
    int orderStart,
    int endOrderDate,
  ) async {
    QuerySnapshot<OrderModel> _orders = await orderFoodCollection
        .where("businessId", isEqualTo: restaurantId)
        .where("status", whereIn: status)
        .orderBy("dateCreate")
        .startAt([orderStart])
        .endAt([endOrderDate])
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _orders.size;
  }

  static Future<Map<String, dynamic>> createOrder(
      OrderModel order, File imagePayment) async {
    try {
      String fileName = basename(imagePayment.path);
      order.imagePayment = await StorageFirebase.uploadImage(
          "images/order/$fileName", imagePayment);
      await orderFoodCollection.add(order.toMap());
      NotificationModel noti = NotificationModel(
        message:
            "มีออร์เดอร์จองอาหาร จำนวน ${order.product.length} รายการ ราคา ${order.totalPrice} กรุณาเช็คหลักฐานการโอนเงิน",
        readingStatus: false,
        recipientId: order.businessId,
        title: "สั่งจองอาหาร",
      );
      await NotificationCollection.createNotification(noti);
      return {"status": "200", "message": "ยืนยันการสั่งจองเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ยืนยันการสั่งจองล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> changeStatus(
      String orderId, status, recipientId) async {
    try {
      String statusText = MyConstant.statusColor[status]!["text"];
      await orderFoodCollection.doc(orderId).update({"status": status});
      NotificationModel noti = NotificationModel(
        message: "ออร์เดอร์การจองของคุณถูก $statusText เรียบร้อยแล้ว",
        readingStatus: false,
        recipientId: recipientId,
        title: "การตอบรับของร้านอาหาร",
      );
      await NotificationCollection.createNotification(noti);
      return {"status": "200", "message": "เปลี่ยนสถานะเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "เปลี่ยนสถานะล้มเหลว"};
    }
  }

  static Future<void> updateReview(String docId) async {
    await orderFoodCollection.doc(docId).update({
      "reviewed": true,
    });
  }

  static Future<QuerySnapshot<OrderModel>> orderFoods(
      int orderStart, int endOrderDate) async {
    QuerySnapshot<OrderModel> _orders = await orderFoodCollection
        .orderBy("dateCreate")
        .startAt([orderStart])
        .endAt([endOrderDate])
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _orders;
  }
}
