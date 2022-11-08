import 'package:chanthaburi_app/pages/intro_apps/intro_app.dart';
import 'package:chanthaburi_app/pages/lets_travel/map_after_filter.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:flutter/material.dart';

class IntroAppService extends StatefulWidget {
  const IntroAppService({Key? key}) : super(key: key);

  @override
  State<IntroAppService> createState() => _IntroAppServiceState();
}

class _IntroAppServiceState extends State<IntroAppService> {
     bool isTravelFilter = false;

  onCheckExistTravelFilter() async {
    List<String>? travelFilter =
        await ShareRefferrence.getTravelFilterCurrent();
    if (travelFilter != null) {
      setState(() {
        isTravelFilter = true;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    onCheckExistTravelFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isTravelFilter ? const MapAfterFilter() : const IntroApp(),
    );
  }
}
