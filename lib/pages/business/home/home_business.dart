import 'package:chanthaburi_app/pages/business/setting/setting_business.dart';
import 'package:chanthaburi_app/pages/notification.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class HomeBusiness extends StatefulWidget {
  Widget businessWidget;
  String businessId;
  String typeBusiness;
  HomeBusiness({
    Key? key,
    required this.businessId,
    required this.businessWidget,
    required this.typeBusiness,
  }) : super(key: key);

  @override
  State<HomeBusiness> createState() => _HomeBusinessState();
}

class _HomeBusinessState extends State<HomeBusiness> {
  int _selected = 0;
  final List<Widget> _widget_bottom_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _widget_bottom_list.insert(0, widget.businessWidget);
      _widget_bottom_list.insert(
        1,
        NotificationRecipient(
          recipientId: widget.businessId,
          theme: MyConstant.colorStore,
        ),
      );
      _widget_bottom_list.insert(
        2,
        SettingBusiness(
          businessId: widget.businessId,
          typeBusiness: widget.typeBusiness,
        ),
      );
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
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selected,
        selectedItemColor: MyConstant.colorStore,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
