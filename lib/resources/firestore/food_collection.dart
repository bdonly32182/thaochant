import 'dart:io';
import 'dart:math';

import 'package:chanthaburi_app/models/restaurant/food.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference foodCollection =
    _firestore.collection(MyConstant.foodCollection);

class FoodCollection {
  static Stream<QuerySnapshot<Object?>> foods(
      String restaurantId, String categoryId) {
    Stream<QuerySnapshot<Object?>> _foods = foodCollection
        .where('restaurantId', isEqualTo: restaurantId)
        .where('categoryId', isEqualTo: categoryId)
        .snapshots();
    return _foods;
  }

  static Future<int> checkFood(String categoryId) async {
    QuerySnapshot _products =
        await foodCollection.where('categoryId', isEqualTo: categoryId).get();
    return _products.size;
  }

  static Future<Map<String, dynamic>> createFood(
      FoodModel foodModel, File? imageFile) async {
    try {
      String imageRef = '';
      if (imageFile != null) {
        String fileName = basename(imageFile.path);
        imageRef = await StorageFirebase.uploadImage(
            "images/food/$fileName", imageFile);
      }
      await foodCollection.add({
        'foodName': foodModel.foodName,
        'price': foodModel.price,
        'imageRef': imageRef,
        'restaurantId': foodModel.restaurantId,
        'categoryId': foodModel.categoryId,
        'description': foodModel.description,
        'status': foodModel.status,
        'optionId': foodModel.optionId,
      });

      return {"status": "200", "message": "สร้างข้อมูลอาหารเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างข้อมูลอาหารล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editFood(
      String foodId, FoodModel food, File? imageFile) async {
    try {
      String imageRef = food.imageRef;
      if (imageFile != null) {
        if (food.imageRef.isNotEmpty) {
          String referenceImage = StorageFirebase.getReference(food.imageRef);
          StorageFirebase.deleteFile(referenceImage);
        }
        String fileName = basename(imageFile.path);
        imageRef = await StorageFirebase.uploadImage(
            "images/food/$fileName", imageFile);
      }
      await foodCollection.doc(foodId).update({
        'foodName': food.foodName,
        'price': food.price,
        'imageRef': imageRef,
        'categoryId': food.categoryId,
        'description': food.description,
        'status': food.status,
        'optionId': food.optionId,
      });
      return {"status": "200", "message": "แก้ไขข้อมูลอาหารเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลอาหารล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteFood(
      String foodId, String imageUrl) async {
    try {
      await foodCollection.doc(foodId).delete();
      if (imageUrl.isNotEmpty) {
        String referenceImage = StorageFirebase.getReference(imageUrl);
        StorageFirebase.deleteFile(referenceImage);
      }
      return {"status": "200", "message": "ลบข้อมูลอาหารเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบข้อมูลอาหารล้มเหลว"};
    }
  }

  static changeStatusFood(String foodId, int status) async {
    try {
      await foodCollection.doc(foodId).update({
        'status': status,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<QuerySnapshot> foodsInRestarurant(String restaurauntId) async {
    QuerySnapshot foods = await foodCollection
        .where('restaurantId', isEqualTo: restaurauntId)
        .get();
    return foods;
  }

  static Future<int> checkFoodInCart(
      String foodName, String restaurantId) async {
    QuerySnapshot _foods = await foodCollection
        .where("restaurantId", isEqualTo: restaurantId)
        .where("foodName", isEqualTo: foodName)
        .get();
    return _foods.size;
  }

  static Future<List<QueryDocumentSnapshot<FoodModel>>> randomFood() async {
    List<QueryDocumentSnapshot<FoodModel>> randomFoods = [];
    List<int> checkList = [];
    QuerySnapshot<FoodModel> _foods = await foodCollection
        .where("imageRef", isNotEqualTo: "")
        .withConverter<FoodModel>(
            fromFirestore: (_firestore, _) =>
                FoodModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    if (_foods.docs.isNotEmpty) {
      final random = Random();
      int indexRandom = random.nextInt(_foods.docs.length);
      int totalInList = 0;
      int totalInQuery = _foods.docs.length > 10 ? 10 : _foods.docs.length;
      while (totalInList < totalInQuery) {
        if (checkList.contains(indexRandom)) {
          indexRandom = random.nextInt(_foods.docs.length);
        } else {
          checkList.add(indexRandom);
          randomFoods.add(_foods.docs[indexRandom]);
          totalInList = randomFoods.length;
        }
      }
    }

    return randomFoods;
  }
}
