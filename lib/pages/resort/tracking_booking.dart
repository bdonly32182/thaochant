import 'package:chanthaburi_app/models/booking/booking.dart';
import 'package:chanthaburi_app/pages/resort/resort_detail.dart';
import 'package:chanthaburi_app/pages/review/write_review.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingBooking extends StatefulWidget {
  TrackingBooking({Key? key}) : super(key: key);

  @override
  State<TrackingBooking> createState() => _TrackingBookingState();
}

class _TrackingBookingState extends State<TrackingBooking> {
  String userId = AuthMethods.currentUser();
  List<String> status = [
    MyConstant.prepaidStatus,
    MyConstant.acceptOrder,
    MyConstant.rejected,
    MyConstant.payed
  ];
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
          stream: BookingCollection.bookingByUserId(userId, status),
          builder:
              (context, AsyncSnapshot<QuerySnapshot<BookingModel>> snapshot) {
            if (snapshot.hasError) {
              return const InternalError();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PouringHourGlass();
            }
            List<QueryDocumentSnapshot<BookingModel>> bookings =
                snapshot.data!.docs;
            return ListView(
              children: [
                ListView.builder(
                  itemCount: bookings.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext cardContext, int index) {
                    DateTime createDate = DateTime.fromMillisecondsSinceEpoch(
                      bookings[index]["dateCreate"],
                    );
                    return FutureBuilder(
                        future: ResortCollection.resortById(
                            bookings[index]["resortId"]),
                        builder:
                            (context, AsyncSnapshot<DocumentSnapshot> resort) {
                          if (resort.hasError) {
                            return const Text('internal error');
                          }
                          if (resort.connectionState ==
                              ConnectionState.waiting) {
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
                                      Text(bookings[index].id),
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
                                        pathImage: resort.data!.get("imageRef"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            resort.data!.get("businessName"),
                                          ),
                                          Text(
                                              'ราคาที่ชำระ ${bookings[index]["prepaidPrice"]} (${bookings[index]["totalRoom"]} ห้อง)'),
                                          Text(
                                              'ราคาทั้งหมด ${bookings[index]["totalPrice"]}'),
                                          Text(
                                            MyConstant.statusColor[
                                                bookings[index]
                                                    ["status"]]!["text"],
                                            style: TextStyle(
                                              color: MyConstant.statusColor[
                                                  bookings[index]
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
                                      child: !bookings[index]["reviewed"]
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
                                                      businessId:
                                                          resort.data!.id,
                                                      businessImage: resort
                                                          .data!
                                                          .get("imageRef"),
                                                      businessName: resort.data!
                                                          .get("businessName"),
                                                      type: 'resort',
                                                      orderDocId:
                                                          bookings[index].id,
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
                                          'จองใหม่',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) => ResortDetail( resortId: resort.data!.id),
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
