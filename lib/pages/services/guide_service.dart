import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
// import 'package:tour_app/pages/guide/list_join_package_tour.dart';
// import '../notification.dart';
// import '../profile.dart';
class GuideService extends StatefulWidget {
  GuideService({Key? key}) : super(key: key);

  @override
  _GuideServiceState createState() => _GuideServiceState();
}

class _GuideServiceState extends State<GuideService> {
  int _selected = 0;
  List<Widget> _widget_bottom_list = [
    // ListJoinPackageTour(),
    // Notifications(),
    // Profile()
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