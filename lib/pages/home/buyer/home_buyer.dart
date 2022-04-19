import 'package:chanthaburi_app/pages/location/locations.dart';
import 'package:chanthaburi_app/pages/otop/home_otop.dart';
import 'package:chanthaburi_app/pages/package_toure/buyer_home_tour.dart';
import 'package:chanthaburi_app/pages/resort/home_resort.dart';
import 'package:chanthaburi_app/pages/restaurant/home_restaurant.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class HomeBuyer extends StatefulWidget {
  HomeBuyer({Key? key}) : super(key: key);

  @override
  State<HomeBuyer> createState() => _HomeBuyerState();
}

class _HomeBuyerState extends State<HomeBuyer> {
  List<Map<String, dynamic>> menuCards = [
    {
      "title": 'ร้านอาหาร',
      "pathImage": MyConstant.thaiFood,
      "goWidget": HomeRestaurant(),
    },
    {
      "title": 'ผลิตภัณฑ์ชุมชน',
      "pathImage": MyConstant.otopPicture,
      "goWidget": HomeOtop(),
    },
    {
      "title": 'บ้านพัก',
      "pathImage": MyConstant.resortPicture,
      "goWidget": HomeResort(),
    },
    {
      "title": 'แหล่งท่องเที่ยว',
      "pathImage": MyConstant.locationPicture,
      "goWidget": Locations(isAdmin: false),
    },
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              height: height * 0.36,
              width: width * 1,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio:
                    height > 730 ? width / height / 0.36 : width / height / 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: List.generate(
                  menuCards.length,
                  (index) => menuCard(
                    context,
                    width,
                    menuCards[index]["goWidget"],
                    menuCards[index]["pathImage"],
                    menuCards[index]["title"],
                  ),
                ),
              ),
            ),
            menuCardPackageTour(
              context,
              width,
              height,
              BuyerHomeTour(),
              MyConstant.packagePicture,
              'แพ็คเกจท่องเที่ยว',
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "กิจกรรมที่น่าสนใจ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildEvent(width, height)
          ],
        ),
      ),
    );
  }

  SizedBox buildEvent(double width, double height) {
    return SizedBox(
      width: width * 1,
      height: height * 0.24,
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (itemBuilder, index) => Container(
          margin: const EdgeInsets.all(10.0),
          width: width * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              MyConstant.packagePicture,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Card menuCard(BuildContext context, double width, Widget gotoWidget,
      String imageUrl, String? title) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => gotoWidget)),
        child: Stack(
          children: [
            SizedBox(
              height: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: width * 1,
              child: Center(
                child: Text(
                  title!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(0, 2.2),
                          blurRadius: 6,
                        )
                      ]),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }

  Card menuCardPackageTour(BuildContext context, double width, double height,
      Widget gotoWidget, String imageUrl, String? title) {
    return Card(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => gotoWidget)),
        child: Stack(
          children: [
            SizedBox(
              width: width * 1,
              height: height * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: width * 1,
              height: height * 0.2,
              child: Center(
                child: Text(
                  title!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(0, 2.2),
                          blurRadius: 6,
                        )
                      ]),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
