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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.colorStore,
          title: const Text('รายการธุรกิจของฉัน'),
          actions: widget.sellerId == null
              ? [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'profile':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => Profile(
                                theme: MyConstant.colorStore,
                              ),
                            ),
                          );
                          break;
                        default:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => CreateStore(
                                title: 'สร้างธุระกิจให้ผู้ประกอบการ',
                                typeBusiness: value,
                                sellerId: _firebaseAuth.currentUser!.uid,
                              ),
                            ),
                          );
                      }
                    },
                    icon: const Icon(Icons.add),
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
                ]
              : [],
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
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
              isAdmin: widget.sellerId != null,
            ),
            MyOtop(
              sellerId: widget.sellerId ?? _firebaseAuth.currentUser!.uid,
              isAdmin: widget.sellerId != null,
            ),
            MyResort(
              sellerId: widget.sellerId ?? _firebaseAuth.currentUser!.uid,
              isAdmin: widget.sellerId != null,
            ),
          ],
        ),
      ),
    );
  }
}
