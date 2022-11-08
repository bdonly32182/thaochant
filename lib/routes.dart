import 'package:chanthaburi_app/pages/home.dart';
import 'package:chanthaburi_app/pages/register_partner.dart';
import 'package:chanthaburi_app/pages/services/introapp_service.dart';
import 'package:flutter/material.dart';
import 'package:chanthaburi_app/pages/authen.dart';
import 'package:chanthaburi_app/pages/create_account.dart';
import 'package:chanthaburi_app/pages/services/admin_service.dart';
import 'package:chanthaburi_app/pages/services/guide_service.dart';
import 'package:chanthaburi_app/pages/services/seller_service.dart';

class Routes {
  static final Map<String, WidgetBuilder> routesMap = {
  '/authen': (BuildContext context) => const Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/adminService': (BuildContext context) => AdminService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/buyerService': (BuildContext context) => const IntroAppService(),
  '/guideService': (BuildContext context) => GuideService(),
  '/registerPartner': (BuildContext context) => RegisterPartner(),
  '/home':(BuildContext context) => const HomeApp(),
};

  static String initialRoute(String role){
    if (role == "admin") {
      return '/adminService';
    }
    if (role == "seller") {
      return '/sellerService';
    }
    if (role == "buyer") {
      return '/buyerService';
    }
    if (role == "guide") {
      return '/guideService';
    }
    return '/buyerService';
  }

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}