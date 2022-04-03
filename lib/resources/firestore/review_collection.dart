import 'dart:io';

import 'package:chanthaburi_app/models/review/review.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/location_collection.dart';
import 'package:chanthaburi_app/resources/firestore/order_food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/order_product_collection.dart';
import 'package:chanthaburi_app/resources/firestore/order_tour_collection.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/resources/firestore/tour_collection.dart';
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

  static Future<Map<String, dynamic>> writeReview(ReviewModel reviewModel,
      File? imageReview, String type, String? docOrderId) async {
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
      if (type == "tour") {
        await TourCollection.setPointLocation(
            reviewModel.businessId, reviewModel.point);
      }

      if (type == "tour_user") {
        await TourCollection.setPointLocation(
            reviewModel.businessId, reviewModel.point);
        await OrderTourCollection.updateReview(docOrderId!);
      }

      if (type == "restaurant") {
        await RestaurantCollection.setPointRestaurant(
          reviewModel.businessId,
          reviewModel.point,
        );
        await OrderFoodCollection.updateReview(docOrderId!);
      }
      if (type == "otop") {
        await OtopCollection.setPointOtop(
          reviewModel.businessId,
          reviewModel.point,
        );
        await OrderProductCollection.updateReview(docOrderId!);
      }
      if (type == "resort") {
        await ResortCollection.setPointResort(
          reviewModel.businessId,
          reviewModel.point,
        );
        await BookingCollection.updateReview(docOrderId!);
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
