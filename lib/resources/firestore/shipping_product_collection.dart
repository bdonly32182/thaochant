import 'package:chanthaburi_app/models/otop/shipping_product.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference shippingProductCollection =
    _firestore.collection(MyConstant.shippingProductCollection);

class ShippingProductColletion {
  static Future<Map<String, dynamic>> saveShippingData(
      ShippingProductModel shipping) async {
    try {
      await shippingProductCollection.add(shipping.toMap());
      return {"status": "200", "message": "แนบข้อมูลจัดส่งเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แนบข้อมูลจัดส่งล้มเหลว"};
    }
  }

  static Stream<QuerySnapshot<ShippingProductModel>> shippingByOrder(
      String orderId) {
    Stream<QuerySnapshot<ShippingProductModel>> shippings =
        shippingProductCollection
            .where("orderId", isEqualTo: orderId)
            .withConverter<ShippingProductModel>(
                fromFirestore: (snapshort, _) =>
                    ShippingProductModel.fromMap(snapshort.data()!),
                toFirestore: (model, _) => model.toMap())
            .snapshots();
    return shippings;
  }

  static Future<Map<String, dynamic>> editShippingProduct(
      ShippingProductModel shipping, String docId) async {
    try {
      await shippingProductCollection.doc(docId).update(shipping.toMap());
      return {"status": "200", "message": "แก้ไขข้อมูลจัดส่งเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลจัดส่งล้มเหลว"};
    }
  }
}
