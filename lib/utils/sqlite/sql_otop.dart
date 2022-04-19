import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteOtop {
  final String  tableProduct = 'orderProduct';
  Future<List<ProductCartModel>> productByUserId(String userId) async {
    Database db = await SQLiteHelper().connectDB();
    List<ProductCartModel> foods = [];
    List<Map<String, dynamic>> foodinRestaurant = await db.rawQuery(
        'SELECT *, SUM(totalPrice) as sumTotalPrice FROM $tableProduct WHERE userId = ? group by businessId',
        [userId]);
    for (var item in foodinRestaurant) {
      ProductCartModel food = ProductCartModel.fromMap(item);
      foods.add(food);
    }
    return foods;
  }

  Future<List<ProductCartModel>> productByRestaurant(
      String restaurantId, String userId) async {
    Database db = await SQLiteHelper().connectDB();
    List<ProductCartModel> foods = [];
    List<Map<String, dynamic>> foodMaps = await db.query(tableProduct,
        where: 'businessId = ? and userId = ?',
        whereArgs: [restaurantId, userId]);
    for (var item in foodMaps) {
      ProductCartModel food = ProductCartModel.fromMap(item);
      foods.add(food);
    }
    return foods;
  }

  Future<void> addProduct(ProductCartModel product) async {
    Database db = await SQLiteHelper().connectDB();
    await db.insert(tableProduct, product.toMap());
    
  }

  Future<void> deleteProduct(String productId, String userId) async {
    Database db = await SQLiteHelper().connectDB();
    await db.delete(tableProduct, where: 'productId = ? and userId =?', whereArgs: [productId, userId]);
  }

  Future<void> deleteProductInOtop(String businessId) async {
    Database db = await SQLiteHelper().connectDB();
    await db.delete(tableProduct, where: 'businessId = ?', whereArgs: [businessId]);
  }

  Future<void> editProduct(
      String productId,userId, int amount, num totalPrice, String addtionMessage) async {
    Database db = await SQLiteHelper().connectDB();
    await db.update(
        tableProduct,
        {
          'amount': amount,
          'totalPrice': totalPrice,
          'addtionMessage': addtionMessage,
        },
        where: 'productId =? and userId =?',
        whereArgs: [productId,userId]);
  }
}