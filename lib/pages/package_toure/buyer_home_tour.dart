import 'package:chanthaburi_app/pages/package_toure/package_tours.dart';
import 'package:chanthaburi_app/pages/package_toure/tracking_tour.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
class BuyerHomeTour extends StatefulWidget {
  BuyerHomeTour({Key? key}) : super(key: key);

  @override
  State<BuyerHomeTour> createState() => _BuyerHomeTourState();
}

class _BuyerHomeTourState extends State<BuyerHomeTour> {
 int _selected = 0;
  final List<Widget> widgetBottomList = [
    PackageTours(isAdmin: false,isBuyer: true,),
    TrackingTour(),
  ];
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
            icon: Icon(Icons.book),
            label: 'ติดตามการจอง',
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