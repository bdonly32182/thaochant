import 'package:chanthaburi_app/pages/create_business/create_store.dart';
import 'package:chanthaburi_app/pages/home/seller/otops/my_otop.dart';
import 'package:chanthaburi_app/pages/home/seller/resorts/my_resort.dart';
import 'package:chanthaburi_app/pages/home/seller/restaurants/my_restaurant.dart';
import 'package:chanthaburi_app/pages/profile/profile.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerService extends StatefulWidget {
  String? sellerId;
  SellerService({Key? key, this.sellerId}) : super(key: key);

  @override
  _SellerServiceState createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int tabValue = 0;
  void onChangeTab(int tab) {
    print('tab : $tab');
    setState(() {
      tabValue = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('tabValue $tabValue');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.colorStore,
          title: const Text('รายการธุรกิจของฉัน'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const Profile(),
                      ),
                    );
                    break;
                  default:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CreateStore(
                          theme: MyConstant.colorStore,
                          title: 'สร้างธุระกิจให้ผู้ประกอบการ',
                          typeBusiness: value,
                        ),
                      ),
                    );
                }
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'restaurant',
                  child: Text('ร้านอาหาร'),
                ),
                const PopupMenuItem(
                  value: 'otop',
                  child: Text('ร้านผลิตภัณฑ์ชุมชน'),
                ),
                const PopupMenuItem(
                  value: 'resort',
                  child: Text('บ้านพัก'),
                ),
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('โปรไฟล์'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            onTap:(int value)=> onChangeTab(value),
            tabs: const [
              Tab(
                icon: Icon(Icons.food_bank_outlined),
                text: "ร้านอาหาร",
              ),
              Tab(
                icon: Icon(
                  Icons.store_mall_directory_outlined,
                ),
                text: "ผลิตภัณฑ์ชุมชน",
              ),
              Tab(
                icon: Icon(
                  Icons.hotel_outlined,
                ),
                text: "บ้านพัก",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyRestaurant(
              sellerId: widget.sellerId ?? _firebaseAuth.currentUser!.uid,
              typeBusiness: tabValue,
            ),
            MyOtop(
              sellerId: widget.sellerId ?? _firebaseAuth.currentUser!.uid,
              typeBusiness: tabValue,
            ),
            MyResort(
              sellerId: widget.sellerId ?? _firebaseAuth.currentUser!.uid,
              typeBusiness: tabValue,
            ),
          ],
        ),
      ),
    );
  }
}
