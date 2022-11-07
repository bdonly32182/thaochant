import 'package:chanthaburi_app/models/business/introduce_business.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference introduceProductCollection =
    _firestore.collection(MyConstant.introduceProductCollection);

class IntroduceProductCollection {
  static Stream<QuerySnapshot<IntroduceProductModel>> introduceProducts() {
    Stream<QuerySnapshot<IntroduceProductModel>> introduces =
        introduceProductCollection
            .withConverter<IntroduceProductModel>(
                fromFirestore: (snapshot, _) =>
                    IntroduceProductModel.fromMap(snapshot.data()!),
                toFirestore: (map, _) => map.toMap())
            .snapshots();
    return introduces;
  }

  static Future<Map<String, dynamic>> upsertIntroduceProduct(
      IntroduceProductModel introduceProductModel, String? docId) async {
    try {
      if (docId == null) {
        await introduceProductCollection.add(introduceProductModel.toMap());
      } else {
        await introduceProductCollection
            .doc(docId)
            .update(introduceProductModel.toMap());
      }
      return {"status": "200", "message": "จัดการแนะนำสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "จัดการแนะนำสินค้าล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteIntroduceProduct(
      String docId) async {
    try {
      await introduceProductCollection.doc(docId).delete();
      return {"status": "200", "message": "ลบแนะนำสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบแนะนำสินค้าล้มเหลว"};
    }
  }
}
