import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chanthaburi_app/pages/register_partner.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/provider/participant_provider.dart';
import 'package:chanthaburi_app/provider/product_provider.dart';
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
import 'package:provider/provider.dart';

final Map<String, WidgetBuilder> routesMap = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/adminService': (BuildContext context) => AdminService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/guideService': (BuildContext context) => GuideService(),
  '/registerPartner': (BuildContext context) => RegisterPartner(),
};
final Map<String, Widget> splashWidget = {
  '/authen': Authen(),
  '/createAccount': CreateAccount(),
  '/adminService': AdminService(),
  '/sellerService': SellerService(),
  '/buyerService': BuyerService(),
  '/guideService': GuideService(),
  '/registerPartner': RegisterPartner(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  String? role = await ShareRefferrence.getRole();
  int ? timeQuestion = await ShareRefferrence.getTimeQuestion();
  if (timeQuestion == null) {
    int dateTime = DateTime.now().millisecondsSinceEpoch;
    await ShareRefferrence.setTimeQuestion(dateTime);
  }
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ParticipantProvider(),
        ),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        title: MyConstant.appName,
        routes: routesMap,
        theme: ThemeData(primaryColor: MyConstant.themeApp),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          splash: MyConstant.appLogo,
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.scaleTransition,
          splashIconSize: 600,
          duration: 1500,
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
      ),
    );
  }
}
