import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteRestaurant {
  final String tableFood = 'orderFood';
  Future<List<ProductCartModel>> foodByUserId(String userId) async {
    Database db = await SQLiteHelper().connectDB();
    List<ProductCartModel> foods = [];
    List<Map<String, dynamic>> foodinRestaurant = await db.rawQuery(
        'SELECT *, SUM(totalPrice) as sumTotalPrice FROM $tableFood WHERE userId = ? group by businessId',
        [userId]);
    for (var item in foodinRestaurant) {
      ProductCartModel food = ProductCartModel.fromMap(item);
      foods.add(food);
    }
    return foods;
  }

  Future<List<ProductCartModel>> foodsByRestaurant(
      String restaurantId, String userId) async {
    Database db = await SQLiteHelper().connectDB();
    List<ProductCartModel> foods = [];
    List<Map<String, dynamic>> foodMaps = await db.query(tableFood,
        where: 'businessId = ? and userId = ?',
        whereArgs: [restaurantId, userId]);
    for (var item in foodMaps) {
      ProductCartModel food = ProductCartModel.fromMap(item);
      foods.add(food);
    }
    return foods;
  }

  Future<void> addFood(ProductCartModel food) async {
    Database db = await SQLiteHelper().connectDB();
    await db.insert(tableFood, food.toMap());
    
  }

  Future<void> deleteFood(String foodId, String userId) async {
    Database db = await SQLiteHelper().connectDB();
    await db.delete(tableFood, where: 'productId = ? and userId =?', whereArgs: [foodId, userId]);
  }

  Future<void> deleteFoodInRestaurant(String restaurantId) async {
    Database db = await SQLiteHelper().connectDB();
    await db.delete(tableFood, where: 'businessId = ?', whereArgs: [restaurantId]);
  }

  Future<void> editFood(
      String productId,userId, int amount, num totalPrice, String addtionMessage) async {
    Database db = await SQLiteHelper().connectDB();
    await db.update(
        tableFood,
        {
          'amount': amount,
          'totalPrice': totalPrice,
          'addtionMessage': addtionMessage,
        },
        where: 'productId =? and userId =?',
        whereArgs: [productId,userId]);
  }
}
