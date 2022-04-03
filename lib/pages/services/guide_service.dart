import 'package:chanthaburi_app/pages/home/guide/guide_tours.dart';
import 'package:chanthaburi_app/pages/home/guide/home_guide.dart';
import 'package:chanthaburi_app/pages/profile/profile.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class GuideService extends StatefulWidget {
  GuideService({Key? key}) : super(key: key);

  @override
  _GuideServiceState createState() => _GuideServiceState();
}

class _GuideServiceState extends State<GuideService> {
  int _selected = 0;
  List<Widget> widgetBottomList = [
    GuideTours(),
    Profile(
      theme: MyConstant.colorGuide,
    )
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
            label: 'My Tour',
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
