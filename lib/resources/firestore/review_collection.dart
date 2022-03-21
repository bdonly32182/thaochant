import 'dart:io';

import 'package:chanthaburi_app/models/review/review.dart';
import 'package:chanthaburi_app/resources/firestore/location_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference reviewCollection =
    _firestore.collection(MyConstant.reviewCollection);

class ReviewCollection {
  static Stream<QuerySnapshot> reviews(String businessId) {
    Stream<QuerySnapshot> _reviews =
        reviewCollection.where('businessId', isEqualTo: businessId).snapshots();
    return _reviews;
  }

  static Future<Map<String, dynamic>> writeReview(
      ReviewModel reviewModel, File? imageReview, String type) async {
    try {
      /* new feature
      if (imageReview != null) {
        String fileName = basename(imageReview.path);
        String url = await StorageFirebase.uploadImage(fileName, imageReview);
        reviewModel.imageRef = url;
      }
      */
      await reviewCollection.add({
        "businessId": reviewModel.businessId,
        "dateTime": reviewModel.dateTime,
        "imageRef": reviewModel.imageRef,
        "message": reviewModel.message,
        "userId": reviewModel.userId,
        "point": reviewModel.point,
      });
      if (type == "location") {
        await LocationCollection.setPointLocation(
            reviewModel.businessId, reviewModel.point);
      }

      return {"status": "200", "message": "เขียนรีวิวเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "เขียนรีวิวล้มเหลว"};
    }
  }

  static Future<void> deleteReview(String businessId) async {
    QuerySnapshot reviews =
        await reviewCollection.where('businessId', isEqualTo: businessId).get();
    for (QueryDocumentSnapshot review in reviews.docs) {
      await reviewCollection.doc(review.id).delete();
    }
  }
}
