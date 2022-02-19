import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/pages/authen.dart';
import 'package:chanthaburi_app/pages/create_account.dart';
import 'package:chanthaburi_app/pages/services/admin_service.dart';
import 'package:chanthaburi_app/pages/services/buyer_service.dart';
import 'package:chanthaburi_app/pages/services/guide_service.dart';
import 'package:chanthaburi_app/pages/services/seller_service.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

final Map<String, WidgetBuilder> routesMap = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/adminService': (BuildContext context) => AdminService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/guideService': (BuildContext context) => GuideService(),
};
final Map<String, Widget> splashWidget = {
  '/authen': Authen(),
  '/createAccount': CreateAccount(),
  '/adminService': AdminService(),
  '/sellerService': SellerService(),
  '/buyerService': BuyerService(),
  '/guideService': GuideService(),
};

String? initialRoute;

Future<Null> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  String? role = await ShareRefferrence.getRole();
  print('###role : $role');
  if (role?.isEmpty ?? true) {
    initialRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (role) {
      case 'admin':
        initialRoute = MyConstant.routeAdminService;
        runApp(MyApp());
        break;
      case 'seller':
        initialRoute = MyConstant.routeSellerService;
        runApp(MyApp());
        break;
      case 'buyer':
        initialRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'guide':
        initialRoute = MyConstant.routeGuideService;
        runApp(MyApp());
        break;
      default:
        initialRoute = MyConstant.routeAuthen;
        runApp(MyApp());
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialFirebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: routesMap,
      theme: ThemeData(primaryColor: MyConstant.themeApp),
      home: AnimatedSplashScreen(
        splash: MyConstant.appLogo,
        backgroundColor: Colors.white,
        splashTransition: SplashTransition.scaleTransition,
        splashIconSize: 600,
        nextScreen: FutureBuilder(
          future: _initialFirebase,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const InternalError();
            }
            return splashWidget[initialRoute] ?? Authen();
          },
        ),
      ),
    );
  }
}
