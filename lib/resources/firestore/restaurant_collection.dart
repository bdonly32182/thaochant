import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/restaurant/restaurant.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference _restaurant =
    _firestore.collection(MyConstant.restaurantCollection);

class RestaurantCollection {
  static Future<Map<String, dynamic>> createRestaurant(
      BusinessModel restaurant) async {
    try {
      await _restaurant.add({
        "businessName": restaurant.businessName,
        "sellerId": restaurant.sellerId,
        "address": restaurant.address,
        "latitude": restaurant.latitude,
        "longitude": restaurant.longitude,
        "dateTime": restaurant.dateTime,
        "statusOpen": restaurant.statusOpen,
        "policyName": restaurant.policyName,
        "policyDescription": restaurant.policyDescription,
        "promptPay": restaurant.promptPay,
        "phoneNumber": restaurant.phoneNumber,
        "link": restaurant.link,
        "imageRef": restaurant.imageRef,
        'categoryRestaurant':restaurant.categoryRestaurant,
      });
      // notification to sellers
      return {"status": "200", "message": "สร้างร้านอาหารเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างร้านอาหารล้มเหลว"};
    }
  }

  static Future<QuerySnapshot<Object?>> myRestaurants(String sellerId) async{
    QuerySnapshot _myRestaurants = await _restaurant.where('sellerId',isEqualTo: sellerId).get();
    return _myRestaurants;
  }
}
