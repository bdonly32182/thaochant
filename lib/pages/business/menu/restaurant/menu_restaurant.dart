import 'package:chanthaburi_app/pages/business/menu/restaurant/menu_list.dart';
import 'package:chanthaburi_app/pages/business/menu/restaurant/option_list.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  String businessId;
  Menu({Key? key, required this.businessId}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyConstant.colorStore,
          title: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: "เมนูหลัก",
              ),
              Tab(
                text: "ตัวเลือกเสริม",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MenuList(
              businessId: widget.businessId,
            ),
            // OptionList(
            //   businessId: widget.businessId,
            // ),
          ],
        ),
      ),
    );
  }
}
