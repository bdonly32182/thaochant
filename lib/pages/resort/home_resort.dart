import 'package:chanthaburi_app/pages/resort/filter_room.dart';
import 'package:chanthaburi_app/pages/resort/tracking_booking.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class HomeResort extends StatefulWidget {
  HomeResort({Key? key}) : super(key: key);

  @override
  State<HomeResort> createState() => _HomeResortState();
}

class _HomeResortState extends State<HomeResort> {
  int _selected = 0;
  final List<Widget> widgetBottomList = [
    FilterRoom(),
    TrackingBooking(),
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
            label: 'บ้านพัก',
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
