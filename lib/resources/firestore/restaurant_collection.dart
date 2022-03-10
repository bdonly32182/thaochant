import 'dart:io';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference restaurant =
    _firestore.collection(MyConstant.restaurantCollection);

class RestaurantCollection {
  static Future<Map<String, dynamic>> createRestaurant(
      BusinessModel restaurantModel, File? imageRef, bool isAdmin) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        restaurantModel.imageRef = await StorageFirebase.uploadImage(
            "images/restaurant/$fileName", imageRef);
      }
      DocumentReference _newRestaurant = await restaurant.add({
        "businessName": restaurantModel.businessName,
        "sellerId": restaurantModel.sellerId,
        "address": restaurantModel.address,
        "latitude": restaurantModel.latitude,
        "longitude": restaurantModel.longitude,
        "statusOpen": restaurantModel.statusOpen,
        "policyName": restaurantModel.policyName,
        "policyDescription": restaurantModel.policyDescription,
        "promptPay": restaurantModel.promptPay,
        "phoneNumber": restaurantModel.phoneNumber,
        "link": restaurantModel.link,
        "imageRef": restaurantModel.imageRef,
      });
      if (isAdmin) {
        NotificationModel _notiModel = NotificationModel(
          message: 'แอดมินสร้างร้านอาหารให้เรียบร้อยแล้ว',
          readingStatus: false,
          recipientId: _newRestaurant.id,
          title: 'แอดมินจัดการร้านอาหาร',
        );
        NotificationCollection.createNotification(_notiModel);
      }
      return {"status": "200", "message": "สร้างร้านอาหารเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างร้านอาหารล้มเหลว"};
    }
  }

  static Stream<QuerySnapshot> myRestaurants(String sellerId) {
    Stream<QuerySnapshot> _myRestaurants =
        restaurant.where('sellerId', isEqualTo: sellerId).snapshots();
    return _myRestaurants;
  }

  static Future<DocumentSnapshot> restaurantById(String restaurantId) async {
    DocumentSnapshot _restaurant = await restaurant.doc(restaurantId).get();
    return _restaurant;
  }

  static Future<Map<String, dynamic>> editRestaurant(
    String restaurantId,
    BusinessModel restaurantModel,
    File? imageUpdate,
  ) async {
    try {
      if (imageUpdate != null) {
        if (restaurantModel.imageRef.isNotEmpty) {
          String imageURL =
              StorageFirebase.getReference(restaurantModel.imageRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(imageUpdate.path);
        restaurantModel.imageRef = await StorageFirebase.uploadImage(
            "images/restaurant/$fileName", imageUpdate);
      }

      await restaurant.doc(restaurantId).update({
        "businessName": restaurantModel.businessName,
        "address": restaurantModel.address,
        "latitude": restaurantModel.latitude,
        "longitude": restaurantModel.longitude,
        "statusOpen": restaurantModel.statusOpen,
        "policyName": restaurantModel.policyName,
        "policyDescription": restaurantModel.policyDescription,
        "promptPay": restaurantModel.promptPay,
        "phoneNumber": restaurantModel.phoneNumber,
        "link": restaurantModel.link,
        "imageRef": restaurantModel.imageRef,
      });
      // if (isAdmin) {
      //   NotificationModel _notiModel = NotificationModel(
      //     message: 'แอดมินแก้ไขร้านอาหารให้เรียบร้อยแล้ว',
      //     readingStatus: false,
      //     recipientId: restaurantId,
      //     title: 'แอดมินจัดการร้านอาหาร',
      //   );
      //   NotificationCollection.createNotification(_notiModel);
      // }

      return {"status": "200", "message": "แก้ไขข้อมูลร้านอาหารรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลร้านอาหารล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteRestaurant(
      String docId, String imageRef) async {
    try {
      await restaurant.doc(docId).delete();
      QuerySnapshot _foods = await FoodCollection.foodsInRestarurant(docId);
      for (QueryDocumentSnapshot food in _foods.docs) {
        await FoodCollection.deleteFood(food.id, food.get('imageRef'));
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
      await restaurant.doc(docId).update({"statusOpen": status});
    } catch (e) {}
  }
}
