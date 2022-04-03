import 'package:chanthaburi_app/models/booking/booking_tour.dart';
import 'package:chanthaburi_app/pages/review/write_review.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/order_tour_collection.dart';
import 'package:chanthaburi_app/resources/firestore/tour_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrackingTour extends StatefulWidget {
  TrackingTour({Key? key}) : super(key: key);

  @override
  State<TrackingTour> createState() => _TrackingTourState();
}

class _TrackingTourState extends State<TrackingTour> {
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
          stream: OrderTourCollection.orderByUserId(userId),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<BookingTourModel>> snapshot) {
            if (snapshot.hasError) {
              return const InternalError();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PouringHourGlass();
            }
            List<QueryDocumentSnapshot<BookingTourModel>> bookings =
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
                        future:
                            TourCollection.tourById(bookings[index]["tourId"]),
                        builder:
                            (context, AsyncSnapshot<DocumentSnapshot> tour) {
                          if (tour.hasError) {
                            return const Text('internal error');
                          }
                          if (tour.connectionState == ConnectionState.waiting) {
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
                                        pathImage: tour.data!.get("imageRef"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tour.data!.get("packageName"),
                                          ),
                                          Text(
                                              'ราคาที่ชำระ ${bookings[index]["totalPrice"]}'),
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
                                                      businessId: tour.data!.id,
                                                      businessImage: tour.data!
                                                          .get("imageRef"),
                                                      businessName: tour.data!
                                                          .get("packageName"),
                                                      type: 'tour_user',
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
