import 'package:flutter/material.dart';

class MyConstant {
  // general
  static String appName = 'GoToChan';

  //mediaquery
  // double width = MediaQuery.of(BuildContext context).size.width;

  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeAdminService = '/adminService';
  static String routeSellerService = '/sellerService';
  static String routeBuyerService = '/buyerService';
  static String routeGuideService = '/guideService';
  static String routeMemberList = '/member';

  // role
  static String buyerName = "buyer";
  static String sellerName = "seller";
  static String adminName = "admin";
  static String guideName = "guide";

  // collection
  static String userCollection = "userCollection";
  static String approvePartnerCollection = "approvePartnerCollection";
  static String restaurantCollection = "restaurantCollection";
  static String otopCollection = "otopCollection";
  static String resortCollection = "resortCollection";
  static String notificationCollection = 'notificationCollection';
  static String categoryCollection = 'categoryCollection';
  static String optionCollection = 'optionCollection';
  static String foodCollection = 'foodCollection';
  static String roomCollection = 'roomCollection';
  static String productOtopCollection = 'productOtopCollection';
  static String optionMenuCollection = 'optionMenuCollection';
  static String locationCollection = 'locationCollection';
  static String reviewCollection = 'reviewCollection';

  // image
  static String appLogo = 'images/logo.png';
  static String iconUser = 'images/user.png';
  static String errorPage = 'images/page_not_found.png';
  static String internalError = 'images/internal_server_error.png';
  static String badRequestError = 'images/bad_request_error.png';
  static String search = 'images/search.png';
  static String noData = 'images/no_data.png';
  static String memberPicture = 'images/friendship.png';
  static String locationImage = 'images/location.jpg';
  static String packageTourImage = 'images/packageTour.jpg';
  static String shopImage = 'images/shop.png';
  static String waiting = 'images/waiting.png';
  static String delivery = 'images/delivery.png';
  static String guideImage = 'images/guide.jpg';
  static String partnerImage = 'images/partner.png';
  static String homestayImage = 'images/homestay.jpg';
  static String currentLocation = 'images/current_location.png';

  // color
  static Color backgroudApp =
      const Color.fromRGBO(243, 241, 245, 1); // box check order this same color
  static Color fontColorSearch = const Color.fromRGBO(200, 198, 198, 1);
  static Color colorStore = const Color.fromRGBO(229, 153, 22, 1);
  static Color colorGuide = const Color.fromRGBO(49, 143, 181, 1);
  static Color themeApp = const Color.fromRGBO(
      41, 187, 137, 1); // this color is themeApp and resort
  static Color colorLocation = const Color.fromRGBO(159, 156, 213, 1);

  // map status
  Map<String, Map<String, dynamic>> statusColor = {
    'Pending': {
      'text': 'สั่งซื้อรอชำระเงิน',
      'color': const Color.fromRGBO(255, 202, 3, 1)
    },
    'WaitAccepted': {
      'text': 'รอตรวจสอบใบเสร็จ',
      'color': const Color.fromRGBO(49, 143, 181, 1)
    },
    'Accepted': {
      'text': 'ยืนยันการชำระเงิน',
      'color': const Color.fromRGBO(110, 203, 99, 1)
    },
    'Rejected': {
      'text': 'ปฏิเสธกาสั่งซื้อ',
      'color': const Color.fromRGBO(218, 0, 55, 1)
    },
    'Shipping': {
      'text': 'จัดส่งแล้ว',
      'color': const Color.fromRGBO(85, 172, 238, 1)
    },
    'Joined': {
      'text': 'เข้าร่วมทริปแล้ว',
      'color': const Color.fromRGBO(85, 172, 238, 1)
    }
  };
  List<String> monthThailand = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฏาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];
}
