import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chanthaburi_app/pages/register_partner.dart';
import 'package:chanthaburi_app/pages/services/introapp_service.dart';
import 'package:chanthaburi_app/routes.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:flutter/material.dart';
import 'package:chanthaburi_app/pages/authen.dart';
import 'package:chanthaburi_app/pages/create_account.dart';
import 'package:chanthaburi_app/pages/services/admin_service.dart';
import 'package:chanthaburi_app/pages/services/buyer_service.dart';
import 'package:chanthaburi_app/pages/services/guide_service.dart';
import 'package:chanthaburi_app/pages/services/seller_service.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool isShow = false;
  String? role;
  final Map<String, Widget> splashWidget = {
    '/authen': const Authen(),
    '/createAccount': CreateAccount(),
    '/adminService': AdminService(),
    '/sellerService': SellerService(),
    '/buyerService': const IntroAppService(),
    '/guideService': GuideService(),
    '/registerPartner': RegisterPartner(),
  };
  @override
  void initState() {
    super.initState();
    getRole();
  }

  getRole() async {
    String? roleRef = await ShareRefferrence.getRole();
    setState(() {
      role = roleRef;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: MyConstant.appLogo,
      backgroundColor: Colors.white,
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 600,
      duration: 600,
      nextScreen: splashWidget[Routes.initialRoute(role ?? '')] ?? const Authen(),
    );
  }
}
