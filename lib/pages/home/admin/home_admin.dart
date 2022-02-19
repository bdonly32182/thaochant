import 'package:chanthaburi_app/pages/home/admin/component/menu_card.dart';
import 'package:chanthaburi_app/pages/userlist/buyer_list.dart';
import 'package:chanthaburi_app/pages/userlist/partner.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  HomeAdmin({Key? key}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyConstant.backgroudApp,
        body: SafeArea(
          child: ListView(
            children: [
              MenuCard(
                gotoWidget: BuyerList(),
                imageUrl: MyConstant.memberPicture,
                title: 'สมาชิกในระบบ',
                titleColor: Colors.green.shade300,
              ),
              MenuCard(
                // gotoWidget: PartnerList(),
                gotoWidget: Partner(),
                imageUrl: MyConstant.partnerImage,
                title: 'พาร์ทเนอร์',
                titleColor: Colors.orange,
              ),
              MenuCard(
                // gotoWidget: PackageTour(isAdmin: true),
                imageUrl: MyConstant.packageTourImage,
                title: 'แพ็คเกจทัวร์',
                titleColor: Colors.blue.shade300,
              ),
              MenuCard(
                // gotoWidget: TourismLocation(isAdmin: true),
                imageUrl: MyConstant.locationImage,
                title: 'แหล่งท่องเที่ยว',
                titleColor: Colors.purple.shade200,
              ),
              MenuCard(
                // gotoWidget: GuideList(),
                imageUrl: MyConstant.guideImage,
                title: 'ไกด์นำเที่ยว',
                titleColor: Colors.pink.shade200,
              ),
            ],
          ),
        ));
  }
}
