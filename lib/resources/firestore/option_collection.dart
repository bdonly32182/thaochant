import 'package:chanthaburi_app/models/option/option.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference optionCollection =
    _firestore.collection(MyConstant.optionCollection);

class OptionCollection {
  static Future<QuerySnapshot> optionList(String businessId) async {
    QuerySnapshot _options =
        await optionCollection.where('businessId', isEqualTo: businessId).get();
    return _options;
  }

  static Future<DocumentSnapshot> option(String optionId) async {
    DocumentSnapshot _option = await optionCollection.doc(optionId).get();
    return _option;
  }

  static Future<Map<String, dynamic>> createOption(OptionModel option) async {
    try {
      await optionCollection.add({
        'businessId': option.businessId,
        'conditionName': option.conditionName,
        'option': option.option,
        'optionName': option.optionName,
        "min": option.min,
        'max': option.max,
      });
      return {"status": "200", "message": "สร้างกลุ่มตัวเลือกเสริมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างกลุ่มตัวเลือกเสริมล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> updateOption(
      OptionModel option, String optionId) async {
    try {
      await optionCollection.doc(optionId).set({
        'businessId': option.businessId,
        'conditionName': option.conditionName,
        'option': option.option,
        'optionName': option.optionName,
        "min": option.min,
        'max': option.max,
      });
      return {"status": "200", "message": "แก้ไขกลุ่มตัวเลือกเสริมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขกลุ่มตัวเลือกเสริมล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteOption(String optionId) async {
    try {
      await optionCollection.doc(optionId).delete();
      return {"status": "200", "message": "ลบกลุ่มตัวเลือกเสริมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบกลุ่มตัวเลือกเสริมล้มเหลว"};
    }
  }
}
