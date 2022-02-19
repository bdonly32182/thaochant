import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _resort =
    _firestore.collection(MyConstant.resortCollection);

class ResortCollection {
  static Future<Map<String, dynamic>> createResort(BusinessModel resort) async {
    try {
      await _resort.add({
        "businessName": resort.businessName,
        "sellerId": resort.sellerId,
        "address": resort.address,
        "latitude": resort.latitude,
        "longitude": resort.longitude,
        "dateTime": resort.dateTime,
        "statusOpen": resort.statusOpen,
        "policyName": resort.policyName,
        "policyDescription": resort.policyDescription,
        "promptPay": resort.promptPay,
        "phoneNumber": resort.phoneNumber,
        "link": resort.link,
        "imageRef": resort.imageRef,
      });
      // notification to sellers
      return {"status": "200", "message": "สร้างบ้านพักเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างบ้านพักล้มเหลว"};
    }
  }

  static Future<QuerySnapshot<Object?>> myResorts(String sellerId) async{
    QuerySnapshot _myResorts = await _resort.where('sellerId',isEqualTo: sellerId).get();
    return _myResorts;
  }
}
