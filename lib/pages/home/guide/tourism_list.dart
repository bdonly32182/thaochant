import 'package:chanthaburi_app/models/booking/booking_tour.dart';
import 'package:chanthaburi_app/resources/firestore/order_tour_collection.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TourismList extends StatefulWidget {
  TourismList({Key? key}) : super(key: key);

  @override
  State<TourismList> createState() => _TourismListState();
}

class _TourismListState extends State<TourismList> {
  List<String> orderCategory = [
    MyConstant.joined,
    MyConstant.rejected,
    MyConstant.payed,
  ];
  int? dateCreate;
  int? endDate;
  DateTime dateNow = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dateCreate =
          DateTime(dateNow.year, dateNow.month, 1).millisecondsSinceEpoch;
      endDate =
          DateTime(dateNow.year, dateNow.month + 1, 0).millisecondsSinceEpoch;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text("รายชื่อนักท่องเที่ยวทั้งเดือน"),
      ),
      body: StreamBuilder(
        stream: OrderTourCollection.orderByAddmin(
            orderCategory, dateCreate!, endDate!),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<BookingTourModel>> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          List<QueryDocumentSnapshot<BookingTourModel>> orderTour =
              snapshot.data!.docs;
          return ListView(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: orderTour.length,
                itemBuilder: (BuildContext memberContext, int index) {
                  return FutureBuilder(
                      future: UserCollection.profile(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Object?>> snapUser) {
                        if (snapUser.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("loading ...");
                        }
                        if (snapshot.hasError) {
                          return const InternalError();
                        }
                        return Card(
                          child: SizedBox(
                            height: height * 0.14,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: width * 0.16,
                                  child:
                                      ShowImage(pathImage: MyConstant.iconUser),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, top: 8.0),
                                          width: width * 0.5,
                                          child: Text(
                                            snapUser.data!.get("fullName"),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: MyConstant.themeApp,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 8.0,
                                            top: 8.0,
                                          ),
                                          width: width * 0.2,
                                          child: Text(
                                            "${orderTour[index].data().dateCreate.day}-${orderTour[index].data().dateCreate.month}-${orderTour[index].data().dateCreate.year}",
                                            style: TextStyle(
                                              color: MyConstant.themeApp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.group,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          (orderTour[index].data().adult +
                                                  orderTour[index]
                                                      .data()
                                                      .senior +
                                                  orderTour[index].data().youth)
                                              .toString(),
                                          style: TextStyle(
                                            color: MyConstant.themeApp,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.monetization_on,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${orderTour[index].data().totalPrice} ฿',
                                          style: TextStyle(
                                            color: MyConstant.themeApp,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.pin_drop,
                                          color: Colors.grey,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 6),
                                          width: width * 0.7,
                                          child: Text(
                                            orderTour[index]
                                                .data()
                                                .addressInfo
                                                .address,
                                            softWrap: true,
                                            maxLines: 3,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: MyConstant.themeApp),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
