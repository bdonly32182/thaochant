import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference categoryCollection =
    _firestore.collection(MyConstant.categoryCollection);

class CategoryCollection {
  static Future<QuerySnapshot<Object?>> categoryList(String businessId) async {
    QuerySnapshot _categories = await categoryCollection
        .where('businessId', isEqualTo: businessId)
        .get();
    return _categories;
  }

  static Future<DocumentSnapshot<Object?>> category(String categoryId) async {
    DocumentSnapshot _categories =
        await categoryCollection.doc(categoryId).get();
    return _categories;
  }

  static Future<Map<String, dynamic>> createCategory(
      String categoryName, String businessId) async {
    try {
      await categoryCollection.add({
        'categoryName': categoryName,
        'businessId': businessId,
      });
      return {"status": "200", "message": "สร้างหมวดหมู่เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างหมวดหมู่ล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editCategory(
      String categoryName, String categoryId) async {
    try {
      await categoryCollection
          .doc(categoryId)
          .update({'categoryName': categoryName});
      return {"status": "200", "message": "แก้ไขหมวดหมู่เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขหมวดหมู่ล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    try {
      await categoryCollection.doc(categoryId).delete();
      return {"status": "200", "message": "แก้ไขหมวดหมู่เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขหมวดหมู่ล้มเหลว"};
    }
  }
}
