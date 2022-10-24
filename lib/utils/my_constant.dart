import 'package:flutter/material.dart';

class MyConstant {
  // general
  static String appName = 'GoToChan';

  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeAdminService = '/adminService';
  static String routeSellerService = '/sellerService';
  static String routeBuyerService = '/buyerService';
  static String routeGuideService = '/guideService';
  static String routeMemberList = '/member';
  static String routeRegisterPartner = '/registerPartner';

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
  static String orderFoodCollection = 'orderFoodCollection';
  static String orderProductCollection = 'orderProductCollection';
  static String shippingAddressCollection = 'shippingAddressCollection';
  static String bookingCollection = "bookingCollection";
  static String packageTourCollection = "packageTourCollection";
  static String orderTourCollection = "orderTourCollection";
  static String eventCollection = "eventCollection";
  static String questionCollection = "questionCollection";
  static String historyClickRestaurantCollection = "historyClickRestaurantCollection";
  static String historyClickOtopCollection = "historyClickOtopCollection";
  static String shippingProductCollection = "shippingProductCollection";

  // type business
  static String typeRestaurant = "restaurant";
  static String typeOtop = "otop";

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
  static String otopImage = 'images/otop.png';
  static String waiting = 'images/waiting.png';
  static String delivery = 'images/delivery.png';
  static String guideImage = 'images/guide.jpg';
  static String partnerImage = 'images/partner.png';
  static String homestayImage = 'images/homestay.jpg';
  static String currentLocation = 'images/location.png';
  static String promptPayImage = 'images/promptpay.jpeg';
  static String notifyImage = 'images/notify.png';
  static String otopPicture= 'images/aluar.jpeg';
  static String locationPicture = 'images/location_image.jpeg';
  static String thaiFood = 'images/thai-food.jpeg';
  static String resortPicture = 'images/baanlek.jpeg';
  static String packagePicture = 'images/package.jpeg';
  static String questionImage = 'images/question.png';
  static String commingSoon = 'images/coming_soon.png';
  static String resetPasswordImage = 'images/reset_password.png';
  static String shimMarker = 'images/shim.png';
  static String shopMarker = 'images/shop_marker.png';

  // color
  static Color backgroudApp =
      const Color.fromRGBO(243, 241, 245, 1); // box check order this same color
  static Color fontColorSearch = const Color.fromRGBO(200, 198, 198, 1);
  static Color colorStore = const Color.fromRGBO(229, 153, 22, 1);
  static Color colorGuide = const Color.fromRGBO(49, 143, 181, 1);
  static Color themeApp = const Color.fromRGBO(
      41, 187, 137, 1); // this color is themeApp and resort
  static Color colorLocation = const Color.fromRGBO(159, 156, 213, 1);
  static Color colorTour = const Color.fromRGBO(160, 191, 225, 1);

  //status restaurant and resort
  static String prepaidStatus = "Prepaid"; // ชำระเงินล่วงหน้าแล้ว
  static String acceptOrder = "Accepted"; // รับออร์เดอร์แล้ว
  static String payed = "Payed"; // จ่ายอีกครึ่งที่เหลือเรียบร้อย
  static String rejected = "Rejected"; // กรณีเช็คเงินแล้วไม่ผ่าน
// more otop
  static String shipping = "Shipping"; // จัดส่งสินค้าแล้ว
  static String received = "Received";
  static String notReceive = "NotReceive";
  // more tour
  static String joined = "Joined"; // เข้าร่วมทริป

  // map status
  static Map<String, Map<String, dynamic>> statusColor = {
    'Payed': {
      'text': 'ชำระเงินเรียบร้อย',
      'color': const Color.fromRGBO(255, 202, 3, 1)
    },
    'Prepaid': {
      'text': 'ชำระเงินล่วงหน้า',
      'color': const Color.fromRGBO(49, 143, 181, 1)
    },
    'Accepted': {
      'text': 'ยืนยันออร์เดอร์',
      'color': const Color.fromRGBO(110, 203, 99, 1)
    },
    'Rejected': {
      'text': 'ปฏิเสธออร์เดอร์',
      'color': const Color.fromRGBO(218, 0, 55, 1)
    },
    'Shipping': {
      'text': 'จัดส่งแล้ว',
      'color': const Color.fromRGBO(85, 172, 238, 1)
    },
    'Joined': {
      'text': 'เข้าร่วมทริปแล้ว',
      'color': const Color.fromRGBO(85, 172, 238, 1)
    },
    'Received': {
      'text': 'ได้รับสินค้าแล้ว',
      'color': const Color.fromRGBO(110, 203, 99, 1)
    },
    'NotReceive': {
      'text': 'ยังไม่ได้รับสินค้า',
      'color': const Color.fromRGBO(218, 0, 55, 1)
    }
  };
  static List<String> monthThailand = [
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
  static Map<String, String> dayThailand = {
    'Monday': "จ.",
    'Tuesday': "อ.",
    'Wednesday': "พ.",
    'Thursday': "พฤ.",
    'Friday': "ศ.",
    'Saturday': "ส.",
    'Sunday': "อา.",
  };
}
