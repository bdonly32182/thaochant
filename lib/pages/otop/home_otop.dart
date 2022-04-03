import 'package:chanthaburi_app/pages/otop/shopping_otop.dart';
import 'package:chanthaburi_app/pages/otop/tracking_order_product.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class HomeOtop extends StatefulWidget {
  HomeOtop({Key? key}) : super(key: key);

  @override
  State<HomeOtop> createState() => _HomeOtopState();
}

class _HomeOtopState extends State<HomeOtop> {
  int _selected = 0;
  final List<Widget> widgetBottomList = [
    ShoppingOtop(),
    TrackingOrderProduct(),
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
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'ติดตามการสั่งซื้อ',
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
