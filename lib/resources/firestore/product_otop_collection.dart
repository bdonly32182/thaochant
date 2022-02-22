import 'package:chanthaburi_app/models/otop/product.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference productOtopCollection =
    _firestore.collection(MyConstant.productOtopCollection);

class ProductOtopCollection {
  static Future<QuerySnapshot> products(
      String otopId, String categoryId) async {
    QuerySnapshot _products = await productOtopCollection
        .where('otopId', isEqualTo: otopId)
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return _products;
  }

  static Future<Map<String, dynamic>> createProduct(
      ProductOtopModel product) async {
    try {
      await productOtopCollection.add({
        'productName': product.productName,
        'price': product.price,
        'imageRef': product.imageRef,
        'otopId': product.otopId,
        'categoryId': product.categoryId,
        'description': product.description,
        'status': product.status,
        'weight': product.weight,
        'width': product.width,
        'height': product.height,
        'long': product.long,
      });
      return {"status": "200", "message": "สร้างข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editProduct(
      String productId, ProductOtopModel product) async {
    try {
      await productOtopCollection.doc(productId).update({
        'productName': product.productName,
        'price': product.price,
        'imageRef': product.imageRef,
        'categoryId': product.categoryId,
        'description': product.description,
        'status': product.status,
        'weight': product.weight,
        'width': product.width,
        'height': product.height,
        'long': product.long,
      });
      return {"status": "200", "message": "แก้ไขข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      await productOtopCollection.doc(productId).delete();
      return {"status": "200", "message": "ลบข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<DocumentSnapshot> productById(String productId) async {
    DocumentSnapshot _product =
        await productOtopCollection.doc(productId).get();
    return _product;
  }
}
