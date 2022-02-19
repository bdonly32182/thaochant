import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference otopCollection =
    _firestore.collection(MyConstant.otopCollection);

class OtopCollection {
  static Future<Map<String, dynamic>> createOtop(BusinessModel otop) async {
    try {
      await otopCollection.add({
        "businessName": otop.businessName,
        "sellerId": otop.sellerId,
        "address": otop.address,
        "latitude": otop.latitude,
        "longitude": otop.longitude,
        "dateTime": otop.dateTime,
        "statusOpen": otop.statusOpen,
        "policyName": otop.policyName,
        "policyDescription": otop.policyDescription,
        "promptPay": otop.promptPay,
        "phoneNumber": otop.phoneNumber,
        "link": otop.link,
        "imageRef": otop.imageRef,
      });
      // notification to sellers
      return {"status": "200", "message": "สร้างร้านผลิตภัณฑ์ชุมชนเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างร้านผลิตภัณฑ์ชุมชนล้มเหลว"};
    }
  }

  static Future<QuerySnapshot<Object?>> myOtops(String sellerId) async{
    QuerySnapshot _myOtops = await otopCollection.where('sellerId',isEqualTo: sellerId).get();
    return _myOtops;
  }
}
