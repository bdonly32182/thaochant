import 'package:chanthaburi_app/pages/introduce_chan/map_shim_shop_shea.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class TabIntroduce extends StatefulWidget {
  TabIntroduce({Key? key}) : super(key: key);

  @override
  State<TabIntroduce> createState() => _TabIntroduceState();
}

class _TabIntroduceState extends State<TabIntroduce> {
  void onTap(int tabNumber) {}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.themeApp,
          bottom: TabBar(
            labelColor: Colors.white,
            onTap: (int tabNumber) => onTap(tabNumber),
            tabs: const [
              Tab(
                icon: Icon(Icons.list_alt_outlined),
                text: "ชิม/ช็อป/แชะ",
              ),
              // Tab(
              //   icon: Icon(
              //     Icons.approval,
              //   ),
              //   text: "อนุมัติพาร์ทเนอร์",
              // ),
            ],
          ),
        ),
        body: TabBarView(
          children: [MapShimShopShea()],
        ),
      ),
    );
  }
}
