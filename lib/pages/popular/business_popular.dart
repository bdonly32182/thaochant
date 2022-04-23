import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/order/order.dart';
import 'package:chanthaburi_app/pages/popular/business_card.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/order_food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessPopular extends StatefulWidget {
  BusinessPopular({Key? key}) : super(key: key);

  @override
  State<BusinessPopular> createState() => _BusinessPopularState();
}

class _BusinessPopularState extends State<BusinessPopular> {
  DateTime selectedDate = DateTime.now();
  String? filterDate(DateTime date) {
    String month = MyConstant.monthThailand[date.month - 1];
    return '$month  ${date.year}';
  }

  List<int> betweenDateFilter(DateTime date) {
    return [
      DateTime(date.year, date.month, 1).millisecondsSinceEpoch,
      DateTime(date.year, date.month + 1, 0).millisecondsSinceEpoch,
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<int> betweenDate = betweenDateFilter(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text("กิจการยอดนิยม"),
        backgroundColor: MyConstant.colorStore,
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShowAndSelectDate(width),
            buildTexxtTitle("ร้านอาหารยอดนิยม"),
            FutureBuilder(
              future: RestaurantCollection.restaurants(),
              builder: (builder,
                  AsyncSnapshot<List<QueryDocumentSnapshot<BusinessModel>>>
                      snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("เกิดเหตุขัดข้อง"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PouringHourGlass();
                }
                List<QueryDocumentSnapshot<BusinessModel>> restaurants =
                    snapshot.data!;
                return BusinessPopularCard(
                  business: restaurants,
                  categories: [MyConstant.acceptOrder, MyConstant.payed],
                  end: betweenDate[1],
                  start: betweenDate[0],
                  type: "ร้านอาหาร",
                );
              },
            ),
            buildTexxtTitle("ร้านผลิตภัณฑ์ยอดนิยม"),
            FutureBuilder(
              future: OtopCollection.otops(),
              builder: (builder,
                  AsyncSnapshot<List<QueryDocumentSnapshot<BusinessModel>>>
                      snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("เกิดเหตุขัดข้อง"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PouringHourGlass();
                }
                List<QueryDocumentSnapshot<BusinessModel>> otops =
                    snapshot.data!;
                return BusinessPopularCard(
                  business: otops,
                  categories: [MyConstant.shipping, MyConstant.received],
                  end: betweenDate[1],
                  start: betweenDate[0],
                  type: "ร้านผลิตภัณฑ์",
                );
              },
            ),
            buildTexxtTitle("บ้านพักยอดนิยม"),
            FutureBuilder(
              future: ResortCollection.allResort(null),
              builder: (builder,
                  AsyncSnapshot<QuerySnapshot<BusinessModel>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("เกิดเหตุขัดข้อง"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PouringHourGlass();
                }
                List<QueryDocumentSnapshot<BusinessModel>> resorts =
                    snapshot.data!.docs;
                return BusinessPopularCard(
                  business: resorts,
                  categories: [MyConstant.acceptOrder, MyConstant.payed],
                  end: betweenDate[1],
                  start: betweenDate[0],
                  type: "บ้านพัก",
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  Container buildTexxtTitle(String title) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row buildShowAndSelectDate(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 15, bottom: 12),
          child: Text(
            '${filterDate(selectedDate)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        buildSelectDate(width),
      ],
    );
  }

  SizedBox buildSelectDate(double width) {
    return SizedBox(
      width: width * .35,
      child: IconButton(
          onPressed: () => buildMaterialDatePicker(context),
          icon: const Icon(Icons.list)),
    );
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'เลือกเดือนและปีที่ต้องการดูรายรับ',
      cancelText: 'ยกเลิก',
      confirmText: 'เลือก',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'dashboard date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
