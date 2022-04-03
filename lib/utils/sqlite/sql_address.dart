import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:sqflite/sqflite.dart';

class SQLAdress {
  final String tableAddress = 'shippingAddress';
  Future<void> createAddress(ShippingModel address) async {
    Database db = await SQLiteHelper().connectDB();
    await db.insert(tableAddress, address.toMap());
  }

  Future<List<ShippingModel>> myAddress(String userId) async {
    List<ShippingModel> _myAdress = [];
    Database db = await SQLiteHelper().connectDB();
    List<Map<String, Object?>> _address =
        await db.query(tableAddress, where: 'userId = ?', whereArgs: [userId]);
    for (var item in _address) {
      ShippingModel address = ShippingModel.fromMap(item);
      _myAdress.add(address);
    }
    return _myAdress;
  }

  Future<void> editAddress(String userId, ShippingModel address) async {
    Database db = await SQLiteHelper().connectDB();
    await db.update(tableAddress, address.toMap(),
        where: 'userId = ?', whereArgs: [userId]);
  }
  Future<void> deleteAddress(String userId) async {
    Database db = await SQLiteHelper().connectDB();
    await db.delete(tableAddress,where: 'userId = ?', whereArgs: [userId]);
  }
}
