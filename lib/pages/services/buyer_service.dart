import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
// import 'package:tour_app/pages/buyer/home_buyer.dart';
// import 'package:tour_app/pages/notification.dart';
// import 'package:tour_app/pages/profile.dart';

class BuyerService extends StatefulWidget {
  BuyerService({Key? key}) : super(key: key);

  @override
  _BuyerServiceState createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  int _selected = 0;
  List<Widget> _widget_bottom_list = [
    // HomeBuyer(),
    // Notifications(),
    // Profile(),
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
        child: _widget_bottom_list[_selected],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
