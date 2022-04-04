import 'package:chanthaburi_app/models/order/order.dart';
import 'package:chanthaburi_app/pages/otop/otop_detail.dart';
import 'package:chanthaburi_app/pages/review/write_review.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/order_product_collection.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingOrderProduct extends StatefulWidget {
  TrackingOrderProduct({Key? key}) : super(key: key);

  @override
  State<TrackingOrderProduct> createState() => _TrackingOrderProductState();
}

class _TrackingOrderProductState extends State<TrackingOrderProduct> {
  String userId = AuthMethods.currentUser();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('ติดตามการจอง'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: OrderProductCollection.orderByUserId(userId),
          builder:
              (context, AsyncSnapshot<QuerySnapshot<OrderModel>> snapshot) {
            if (snapshot.hasError) {
              return const InternalError();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PouringHourGlass();
            }
            List<QueryDocumentSnapshot<OrderModel>> orders =
                snapshot.data!.docs;
            return ListView(
              children: [
                ListView.builder(
                  itemCount: orders.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext cardContext, int index) {
                    DateTime createDate = DateTime.fromMillisecondsSinceEpoch(
                      orders[index]["dateCreate"],
                    );
                    return FutureBuilder(
                        future: OtopCollection.otopById(
                            orders[index]["businessId"]),
                        builder:
                            (context, AsyncSnapshot<DocumentSnapshot> otop) {
                          if (otop.hasError) {
                            return const Text('internal error');
                          }
                          if (otop.connectionState == ConnectionState.waiting) {
                            return const Text('loading ...');
                          }
                          return Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(orders[index].id),
                                      Text(
                                          "${createDate.year}-${createDate.month}-${createDate.day}")
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10.0),
                                      width: width * 0.30,
                                      height: 120,
                                      child: ShowImageNetwork(
                                        colorImageBlank: MyConstant.themeApp,
                                        pathImage: otop.data!.get("imageRef"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            otop.data!.get("businessName"),
                                          ),
                                          Text(
                                              'ราคาที่ชำระ ${orders[index]["totalPrice"]} ฿ (${orders[index]["product"].length}รายการ)'),
                                          Text(
                                            MyConstant.statusColor[orders[index]
                                                ["status"]]!["text"],
                                            style: TextStyle(
                                              color: MyConstant.statusColor[
                                                  orders[index]
                                                      ["status"]]!["color"],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: !orders[index]["reviewed"]
                                          ? ElevatedButton(
                                              child: Text(
                                                'ให้คะแนน',
                                                style: TextStyle(
                                                    color: MyConstant.themeApp),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (builder) =>
                                                        WriteReview(
                                                      theme:
                                                          MyConstant.themeApp,
                                                      businessId: otop.data!.id,
                                                      businessImage: otop.data!
                                                          .get("imageRef"),
                                                      businessName: otop.data!
                                                          .get("businessName"),
                                                      type: 'otop',
                                                      orderDocId:
                                                          orders[index].id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: ElevatedButton(
                                        child: const Text(
                                          'สั่งใหม่',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) => OtopDetail(
                                                otopId: orders[index]
                                                    ["businessId"],
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: MyConstant.themeApp),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
