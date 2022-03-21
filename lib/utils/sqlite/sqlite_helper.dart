import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  final String dbName = 'chan.db';
  final String tableFood = 'orderFood';
  final String tableProduct = 'orderProduct';
  int version = 1;

  String id = "id";
  String businessId = "businessId";
  String businessName = "businessName";
  String userId = "userId";
  String productId = "productId";
  String productName = "productName";
  String amount = "amount";
  String totalPrice = "totalPrice";
  String price = "price";
  String imageURL = "imageURL";
  String addtionMessage = "addtionMessage";

  SQLiteHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: _createDB,
      version: version,
    );
  }

  Future _createDB(Database db, int version) async {
    String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    String textType = 'TEXT NOT NULL';
    String integerType = 'INTEGER NOT NULL';
    String numType = 'num NOT NULL';

    await db.execute('''
    CREATE TABLE $tableFood(
      $id $idType,
      $productId $textType,
      $productName $textType,
      $businessId $textType,
      $amount $integerType,
      $totalPrice $numType,
      $price $numType,
      $businessName $textType,
      $userId $textType,
      $imageURL $textType,
      $addtionMessage $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableProduct(
      $id $idType,
      $productId $textType,
      $productName $textType,
      $businessId $textType,
      $amount $integerType,
      $totalPrice $numType,
      $price $numType,
      $businessName $textType,
      $userId $textType,
      $imageURL $textType,
      $addtionMessage $textType
    )
    ''');
  }

  Future<Database> connectDB() async {
    return openDatabase(join(await getDatabasesPath(), dbName));
  }

  close() async {
    Database db = await openDatabase(join(await getDatabasesPath(), dbName));
    db.close();
  }
}
