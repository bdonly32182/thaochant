import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference optionMenuCollection =
    _firestore.collection(MyConstant.optionMenuCollection);

class OptionMenuCollection {
  static Future<QuerySnapshot> optionMenuList(String optionId) async {
    QuerySnapshot _optionMenus =
        await optionMenuCollection.where("optionId", isEqualTo: optionId).get();
    return _optionMenus;
  }

  static Future<DocumentSnapshot> optionMenu(String menuId) async {
    DocumentSnapshot _optionMenu = await optionMenuCollection.doc(menuId).get();
    return _optionMenu;
  }

  static Future<Map<String, dynamic>> createOptionMenu(
      String optionMenuName, double price, String optionId, bool status) async {
    try {
      await optionMenuCollection.add({
        "optionMenuName": optionMenuName,
        "price": price,
        "optionId": optionId,
        "status": status,
      });
      return {"status": "200", "message": "สร้างตัวเลือกเสริมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างตัวเลือกเสริมล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editOptionMenu(String optionMenuId,
      String optionMenuName, double price, bool status) async {
    try {
      await optionMenuCollection.doc(optionMenuId).update({
        "optionMenuName": optionMenuName,
        "price": price,
        "status": status,
      });
      return {"status": "200", "message": "แก้ไขตัวเลือกเสริมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขตัวเลือกเสริมล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteOptionMenu(String optionMenuId) async {
    try {
      await optionMenuCollection.doc(optionMenuId).delete();
      return {"status": "200", "message": "ลบตัวเลือกเสริมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบตัวเลือกเสริมล้มเหลว"};
    }
  } 
  
  static deleteOptionMenuWithOption(String optionId) async {
    QuerySnapshot optionMenus = await optionMenuList(optionId);
    for (var element in optionMenus.docs) {
      await deleteOptionMenu(element.id);
     }
  }

}
