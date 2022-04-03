import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference addressCollection =
    _firestore.collection(MyConstant.shippingAddressCollection);

class ShippingAddressCollection {

  static Stream<QuerySnapshot<ShippingModel>> myAddress(String userId)  {
    Stream<QuerySnapshot<ShippingModel>> _adress =
         addressCollection.where('userId', isEqualTo: userId)
        .withConverter<ShippingModel>(
            fromFirestore: (snapshot, _) =>
                ShippingModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _adress;
  }

  static Future<Map<String, dynamic>> createAddress(
      ShippingModel address) async {
    try {
      await addressCollection.add(address.toMap());
      return {"status": "200", "message": "สร้างที่อยู่เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างที่อยู่ล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editAddress(
      String docId, ShippingModel address) async {
    try {
      await addressCollection.doc(docId).update(address.toMap());
      return {"status": "200", "message": "แก้ไขที่อยู่เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขที่อยู่ล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteAddress(String docId) async {
    try {
      await addressCollection.doc(docId).delete();
      return {"status": "200", "message": "ลบที่อยู่เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบที่อยู่ล้มเหลว"};
    }
  }
}
