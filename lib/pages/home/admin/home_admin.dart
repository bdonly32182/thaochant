import 'package:chanthaburi_app/pages/events/events.dart';
import 'package:chanthaburi_app/pages/guide/guide_list.dart';
import 'package:chanthaburi_app/pages/home/admin/component/menu_card.dart';
import 'package:chanthaburi_app/pages/location/locations.dart';
import 'package:chanthaburi_app/pages/package_toure/package_tours.dart';
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
  List<Map<String, dynamic>> menuCards = [
    {
      "title": 'สมาชิกในระบบ',
      "pathImage": MyConstant.memberPicture,
      "goWidget": const BuyerList(),
    },
    {
      "title": 'พาร์ทเนอร์',
      "pathImage": MyConstant.partnerImage,
      "goWidget": Partner(),
    },
    {
      "title": 'แพ็คเกจทัวร์',
      "pathImage": MyConstant.packageTourImage,
      "goWidget": PackageTours(
        isAdmin: true,
        isBuyer: false,
      ),
    },
    {
      "title": 'แหล่งท่องเที่ยว',
      "pathImage": MyConstant.locationImage,
      "goWidget": Locations(isAdmin: true),
    },
    {
      "title": 'ไกด์นำเที่ยว',
      "pathImage": MyConstant.guideImage,
      "goWidget": GuideList(),
    },
    {
      "title": 'กิจกรรม',
      "pathImage": MyConstant.notifyImage,
      "goWidget": EventList(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SingleChildScrollView(
        child: SizedBox(
          height: height * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome To",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyConstant.themeApp,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Our Service",
                  style: TextStyle(
                    fontSize: 16,
                    color: MyConstant.themeApp,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                height: height * 0.86,
                width: width * 1,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio:
                      height > 730 ? width / height / 0.4 : width / height / 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: List.generate(
                    menuCards.length,
                    (index) => MenuCard(
                      gotoWidget: menuCards[index]["goWidget"],
                      imageUrl: menuCards[index]["pathImage"],
                      title: menuCards[index]["title"],
                      titleColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
