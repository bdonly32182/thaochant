import 'dart:io';
import 'dart:math';

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
  static Future<List<QueryDocumentSnapshot<BusinessModel>>>
      restaurants() async {
    List<QueryDocumentSnapshot<BusinessModel>> randomRestaurant = [];
    List<int> checkList =
        []; // เพราะว่า  withConverter<BusinessModel> ไม่สามารถเช็คได้เลยสร้างมาแค่เช็คอินเด็กพอ
    QuerySnapshot<BusinessModel> _restuarants = await restaurant
        .withConverter<BusinessModel>(
            fromFirestore: (_firestore, _) =>
                BusinessModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    if (_restuarants.docs.isNotEmpty) {
      final random = Random();
      int indexRandom = random.nextInt(_restuarants.docs.length);
      int totalInList = 0;
      int totalInQuery = _restuarants.docs.length;
      while (totalInList < totalInQuery) {
        if (checkList.contains(indexRandom)) {
          indexRandom = random.nextInt(_restuarants.docs.length);
        } else {
          checkList.add(indexRandom);
          randomRestaurant.add(_restuarants.docs[indexRandom]);
          totalInList = randomRestaurant.length;
        }
      }
    }

    return randomRestaurant;
  }

  static Future<List<QueryDocumentSnapshot<BusinessModel>>> searchRestaurant(
      String search) async {
    QuerySnapshot<BusinessModel> _resultRestaurant = await restaurant
        .withConverter<BusinessModel>(
            fromFirestore: (snapshot, _) =>
                BusinessModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    List<QueryDocumentSnapshot<BusinessModel>> searchRestaurants =
        _resultRestaurant
            .docs
            .where((business) =>
                business.data().businessName.toLowerCase().contains(search))
            .toList();
    // .orderBy("businessName")
    // .startAt([search]).endAt([search + '\uf8ff']).get();
    return searchRestaurants;
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
      return {"status": "200", "message": "ลบข้อมูลร้านอาหารเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบข้อมูลร้านอาหารล้มเหลว"};
    }
  }

  static Future<void> changeStatus(String docId, int status) async {
    try {
      await restaurant.doc(docId).update({"statusOpen": status});
    } catch (e) {}
  }
}
