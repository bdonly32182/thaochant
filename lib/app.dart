import 'package:chanthaburi_app/pages/home.dart';
import 'package:chanthaburi_app/routes.dart';
import 'package:chanthaburi_app/utils/firebase_messaging_services.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initilizeFirebaseMessaging();
    checkNotifications();
  }

  initilizeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }
  
  checkNotifications() async {
    await Provider.of<NotificationServices>(context, listen: false).checkForNotifications();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      title: MyConstant.appName,
      routes: Routes.routesMap,
      theme: ThemeData(primaryColor: MyConstant.themeApp),
      debugShowCheckedModeBanner: false,
      home: const HomeApp()
    );
  }
}
