import 'dart:io';
import 'dart:math';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/utils/get_random_element.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference restaurant =
    _firestore.collection(MyConstant.restaurantCollection);

class RestaurantCollection {
  static Future<QuerySnapshot>
      restaurants(DocumentSnapshot? lastDocument) async {
    // if (lastDocument != null) {
    //   QuerySnapshot _loadMoreRestaurant = await restaurant
    //       .orderBy("statusOpen", descending: true)
    //       .startAfterDocument(lastDocument)
    //       .limit(3)
    //       .get();
    //   return _loadMoreRestaurant;
    // }
    // List<QueryDocumentSnapshot<BusinessModel>> randomRestaurant = [];
    // QuerySnapshot<BusinessModel> _restuarants = await restaurant
    //     .withConverter<BusinessModel>(
    //         fromFirestore: (_firestore, _) =>
    //             BusinessModel.fromMap(_firestore.data()!),
    //         toFirestore: (model, _) => model.toMap())
    //     .get();
    // for (var i = 0; i < _restuarants.docs.length; i++) {
    //   QueryDocumentSnapshot<BusinessModel> businessModel =
    //       getRandomElement(_restuarants.docs);
    //   randomRestaurant.add(businessModel);
    // }
    // final random = Random();
    // int indexCurrent = 0;
    // int indexRandom = 0;
    // int totalInList = randomRestaurant.length;
    // int totalInQuery = _restuarants.docs.length;
    // while (indexCurrent != indexRandom && totalInList != totalInQuery) {
    //   if (indexRandom != indexCurrent) {

    //     randomRestaurant.add(_restuarants.docs[indexRandom]);
    //     indexCurrent = indexRandom;
    //   } else {
    //     indexRandom = random.nextInt(_restuarants.docs.length);
    //   }
    // }
    // return randomRestaurant;
    if (lastDocument != null) {
      QuerySnapshot _loadMoreRestaurant = await restaurant
          .orderBy("statusOpen", descending: true)
          .startAfterDocument(lastDocument)
          .limit(20)
          .get();
      return _loadMoreRestaurant;
    }
    QuerySnapshot _restuarants = await restaurant
        .orderBy("statusOpen", descending: true)
        .limit(20)
        .get();
    return _restuarants;
  }

  static Future<QuerySnapshot> searchRestaurant(String search) async {
    QuerySnapshot _resultUser = await restaurant
        .orderBy("businessName")
        .startAt([search]).endAt([search + '\uf8ff']).get();
    return _resultUser;
  }

  static Future<Map<String, dynamic>> createRestaurant(
      BusinessModel restaurantModel,
      File? imageRef,
      File? qrcodeImage,
      bool isAdmin) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        restaurantModel.imageRef = await StorageFirebase.uploadImage(
            "images/restaurant/$fileName", imageRef);
      }
      if (qrcodeImage != null) {
        String fileName = basename(qrcodeImage.path);
        restaurantModel.qrcodeRef = await StorageFirebase.uploadImage(
            "images/qrcode/$fileName", qrcodeImage);
      }
      DocumentReference _newRestaurant =
          await restaurant.add(restaurantModel.toMap());
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

  static Future<void> setPointRestaurant(String docId, num point) async {
    try {
      restaurant.doc(docId).update({
        "point": FieldValue.increment(point),
        "ratingCount": FieldValue.increment(1),
      });
    } catch (e) {}
  }

  static Future<Map<String, dynamic>> editRestaurant(
    String restaurantId,
    BusinessModel restaurantModel,
    File? imageUpdate,
    File? qrcodeUpdate,
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

      if (qrcodeUpdate != null) {
        if (restaurantModel.qrcodeRef.isNotEmpty) {
          String imageURL =
              StorageFirebase.getReference(restaurantModel.qrcodeRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(qrcodeUpdate.path);
        restaurantModel.qrcodeRef = await StorageFirebase.uploadImage(
            "images/qrcode/$fileName", qrcodeUpdate);
      }

      await restaurant.doc(restaurantId).update(restaurantModel.toMap());
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
