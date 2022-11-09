import 'package:chanthaburi_app/models/business/introduce_business.dart';
import 'package:chanthaburi_app/models/events/event_model.dart';
import 'package:chanthaburi_app/models/history/history.dart';
import 'package:chanthaburi_app/models/lets_travel/history_introduce_travel.dart';
import 'package:chanthaburi_app/models/lets_travel/location_travel.dart';
import 'package:chanthaburi_app/pages/lets_travel/event_question.dart';
import 'package:chanthaburi_app/pages/lets_travel/introduce_product_question.dart';
import 'package:chanthaburi_app/pages/lets_travel/map_after_filter.dart';
import 'package:chanthaburi_app/pages/lets_travel/sequence_question.dart';
import 'package:chanthaburi_app/pages/services/buyer_service.dart';
import 'package:chanthaburi_app/resources/firestore/event_collection.dart';
import 'package:chanthaburi_app/resources/firestore/history_introduce_travel_collection.dart';
import 'package:chanthaburi_app/resources/firestore/introduce_product_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/map/calculate_distance.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class QuestionFilter extends StatefulWidget {
  const QuestionFilter({Key? key}) : super(key: key);

  @override
  State<QuestionFilter> createState() => _QuestionFilterState();
}

class _QuestionFilterState extends State<QuestionFilter> {
  final PageController controller = PageController(initialPage: 0);
  num usageTime = 0;
  List<IntroduceProductModel> selectIntro = [];
  List<EventModel> selectEvent = [];
  QuerySnapshot<IntroduceProductModel>? introProds;
  QuerySnapshot<EventModel>? events;
  List<String> introProdId = [];
  List<String> eventId = [];
  double? lat, lng;
  void checkPermission() async {
    try {
      Position positionBuyer = await determinePosition();
      setState(() {
        lat = positionBuyer.latitude;
        lng = positionBuyer.longitude;
      });
    } catch (e) {
      PermissionStatus locationStatus = await Permission.location.status;
      if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Location',
          'โปรดแชร์ Location',
        );
      }
    }
  }

  Future<void> setDataToReference(List<IntroduceProductModel> selectedIntros,
      List<EventModel> selectedEvents) async {
    if (lat != null && lng != null) {
      List<String> locations = [];

      for (int i = 0; i < selectedIntros.length; i++) {
        IntroduceProductModel intro = selectedIntros[i];
        double distance = CalculateDistance.calculateDistance(
            intro.lat, intro.lng, lat!, lng!);
        LocationTravelModel location = LocationTravelModel(
          lat: intro.lat,
          title: intro.name,
          lng: intro.lng,
          snippet: 'ระยะทาง: $distance กิโลเมตร',
          type: "intro",
          distance: distance,
        );
        locations.add(location.toJson());
      }
      for (int i = 0; i < selectedEvents.length; i++) {
        EventModel event = selectedEvents[i];
        double distance = CalculateDistance.calculateDistance(
            event.lat, event.lng, lat!, lng!);
        LocationTravelModel location = LocationTravelModel(
          lat: event.lat,
          title: event.eventName,
          lng: event.lng,
          snippet: 'ระยะทาง: $distance กิโลเมตร',
          type: 'event',
          distance: distance,
        );
        locations.add(location.toJson());
      }
      await ShareRefferrence.setTravelFilterCurrent(locations);
    }
  }

  onChangeUsageTime(num useTime) {
    setState(() {
      usageTime = useTime;
      if (selectEvent.isNotEmpty) {
        selectEvent = [];
      }
    });
  }

  onSelectIntroProd(IntroduceProductModel introProd, String id) {
    setState(() {
      selectIntro.add(introProd);
      introProdId.add(id);
    });
  }

  onRemoveIntroProd(IntroduceProductModel introProd, String id) {
    setState(() {
      introProdId.remove(id);
      selectIntro.removeWhere((element) =>
          element.businessId == introProd.businessId &&
          element.name == introProd.name);
    });
  }

  onSelectEvent(EventModel eventModel, String id) {
    setState(() {
      eventId.add(id);
      selectEvent.add(eventModel);
    });
  }

  onRemoveEvent(EventModel eventModel, String id) {
    setState(() {
      eventId.remove(id);
      selectEvent.removeWhere((element) =>
          element.url == eventModel.url &&
          element.eventName == eventModel.eventName);
    });
  }

  fetchEventAndIntroProd() async {
    QuerySnapshot<EventModel> respEvent = await EventCollection.events2();
    QuerySnapshot<IntroduceProductModel> respIntro =
        await IntroduceProductCollection.introduceProducts2();
    setState(() {
      events = respEvent;
      introProds = respIntro;
    });
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    fetchEventAndIntroProd();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: MyConstant.backgroudApp,
        title: Text(
          "แนะนำสถานที่ท่องเที่ยว",
          style: TextStyle(
            color: MyConstant.themeApp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => BuyerService(),
                  ),
                  (route) => false);
            },
            child: const Text('SKIP'),
            style: TextButton.styleFrom(primary: MyConstant.themeApp),
          ),
        ],
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: introProds == null && events == null
          ? const PouringHourGlass()
          : Container(
              padding: EdgeInsets.only(bottom: height * 0.1),
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: <Widget>[
                  SequenceQuestion(
                    selected: usageTime,
                    onChange: onChangeUsageTime,
                  ),
                  IntroduceProductQuestion(
                    onSelected: onSelectIntroProd,
                    selects: selectIntro,
                    onRemove: onRemoveIntroProd,
                    intros: introProds!,
                  ),
                  EventQuestion(
                    events: events!,
                    onRemove: onRemoveEvent,
                    onSelected: onSelectEvent,
                    selects: selectEvent,
                    usageTime: usageTime,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MyConstant.fillForm),
                  fit: BoxFit.contain,
                ),
              ),
            ),
      bottomSheet: Container(
        height: height * 0.1,
        decoration: BoxDecoration(color: MyConstant.backgroudApp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('PREVIOUS'),
              style: TextButton.styleFrom(primary: MyConstant.themeApp),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: WormEffect(
                activeDotColor: MyConstant.themeApp,
              ),
            ),
            TextButton(
              onPressed: () async {
                double? pageNumber = controller.page;
                if (pageNumber == 0 && usageTime == 0) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือก 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 1 && selectIntro.isEmpty) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือกอย่างน้อย 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 2 && selectEvent.isEmpty) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือกอย่างน้อย 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 2 && selectEvent.isNotEmpty) {
                  HistoryIntroduceTravelModel history =
                      HistoryIntroduceTravelModel(
                    usageTime: usageTime,
                    introProdId: introProdId,
                    eventId: eventId,
                  );
                  await setDataToReference(selectIntro, selectEvent);
                  await HistoryIntroduceTravelCollection.saveHistory(history);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const MapAfterFilter(),
                      ),
                      (route) => false);
                }
                controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('NEXT'),
              style: TextButton.styleFrom(primary: MyConstant.themeApp),
            ),
          ],
        ),
      ),
    );
  }
}
