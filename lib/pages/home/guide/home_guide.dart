import 'package:chanthaburi_app/models/packagetour/package_tour.dart';
import 'package:chanthaburi_app/pages/home/guide/tourism_list.dart';
import 'package:chanthaburi_app/pages/package_toure/package_detail.dart';
import 'package:chanthaburi_app/pages/profile/profile.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class HomePackageTour extends StatefulWidget {
  PackageTourModel tour;
  String tourId;
  HomePackageTour({
    Key? key,
    required this.tour,
    required this.tourId,
  }) : super(key: key);

  @override
  State<HomePackageTour> createState() => _HomePackageTourState();
}

class _HomePackageTourState extends State<HomePackageTour> {
  int _selected = 0;
  List<Widget> widgetBottomList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widgetBottomList = [
        PackageDetail(tour: widget.tour, tourId: widget.tourId, isBuyer: false),
        TourismList(),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widgetBottomList[_selected],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'แพ็คเกจทัวร์',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'นักท่องเที่ยว',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selected,
        selectedItemColor: MyConstant.themeApp,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
