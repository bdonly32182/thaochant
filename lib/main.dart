import 'package:chanthaburi_app/app.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/provider/participant_provider.dart';
import 'package:chanthaburi_app/provider/product_provider.dart';
import 'package:chanthaburi_app/utils/firebase_messaging_services.dart';
import 'package:chanthaburi_app/utils/notification_services.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  int? timeQuestion = await ShareRefferrence.getTimeQuestion();
  if (timeQuestion == null) {
    int dateTime = DateTime.now().millisecondsSinceEpoch;
    await ShareRefferrence.setTimeQuestion(dateTime);
  }
  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationServices>(
          create: (context) => NotificationServices(),
        ),
        Provider<FirebaseMessagingService>(
          create: (context) => FirebaseMessagingService(context.read<NotificationServices>()),
        ),
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
      child: MyApp(),
    ),
  );
}
