import 'package:chanthaburi_app/models/booking/booking.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardResort extends StatefulWidget {
  String resortId, imageRef, resortName;
  DashboardResort({
    Key? key,
    required this.resortId,
    required this.imageRef,
    required this.resortName,
  }) : super(key: key);

  @override
  State<DashboardResort> createState() => _DashboardResortState();
}

class _DashboardResortState extends State<DashboardResort> {
  DateTime selectedDate = DateTime.now();
  List<String> orderCategory = [
    MyConstant.acceptOrder,
    MyConstant.prepaidStatus,
    MyConstant.rejected,
    MyConstant.payed,
  ];
  bool focusIncomeMonth = true;
  bool focusIncomeYear = false;
  bool focusSelectDate = false;
  String type = 'month';
  int? dateCreate;
  int? endDate;
  String? filterDate(DateTime date, String type) {
    if (type == 'year') {
      return 'ปี ${date.year}';
    }
    if (type == 'month') {
      String month = MyConstant.monthThailand[date.month - 1];
      return '$month  ${date.year}';
    }
  }

  List<int> betweenDateFilter(DateTime date, String type) {
    if (type == "year") {
      return [
        //index 0 = start date, index 1 = end date
        DateTime(date.year).millisecondsSinceEpoch,
        DateTime(date.year + 1).millisecondsSinceEpoch,
      ];
    }
    return [
      //index 0 = start date, index 1 = end date
      DateTime(date.year, date.month, 1).millisecondsSinceEpoch,
      DateTime(date.year, date.month + 1, 0).millisecondsSinceEpoch,
    ];
  }

  double calculateTotalPrice(
      List<QueryDocumentSnapshot<BookingModel>> prepaids,
      List<QueryDocumentSnapshot<BookingModel>> accepts,
      List<QueryDocumentSnapshot<BookingModel>> payeds,
      List<QueryDocumentSnapshot<BookingModel>> rejects) {
    double totalPrice = 0;
    for (QueryDocumentSnapshot<BookingModel> prepaid in prepaids) {
      totalPrice += prepaid.data().totalPrice;
    }
    for (QueryDocumentSnapshot<BookingModel> accept in accepts) {
      totalPrice += accept.data().totalPrice;
    }
    for (QueryDocumentSnapshot<BookingModel> payed in payeds) {
      totalPrice += payed.data().totalPrice;
    }
    for (QueryDocumentSnapshot<BookingModel> reject in rejects) {
      totalPrice += reject.data().totalPrice;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<int> betweenDate = betweenDateFilter(selectedDate, type);
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildResort(width, height, widget.imageRef, widget.resortName),
              buildFilterDashboard(),
              buildShowAndSelectDate(width),
              StreamBuilder(
                  stream: BookingCollection.orderByResort(widget.resortId,
                      orderCategory, betweenDate[0], betweenDate[1]),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<BookingModel>> snapshot) {
                    if (snapshot.hasError) {
                      return const InternalError();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const PouringHourGlass();
                    }
                    List<QueryDocumentSnapshot<BookingModel>> orders =
                        snapshot.data!.docs;
                    List<QueryDocumentSnapshot<BookingModel>> orderPrepaid =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.prepaidStatus)
                            .toList();
                    List<QueryDocumentSnapshot<BookingModel>> orderAccept =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.acceptOrder)
                            .toList();
                    List<QueryDocumentSnapshot<BookingModel>> orderPayed =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.payed)
                            .toList();
                    List<QueryDocumentSnapshot<BookingModel>> orderReject =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.rejected)
                            .toList();
                    return Column(
                      children: [
                        buildOrderList('ออร์เดอร์จ่ายล่วงหน้า',
                            orderPrepaid.length.toString()),
                        buildOrderList('ออร์เดอร์ที่อนุมัติ',
                            orderAccept.length.toString()),
                        buildOrderList('ออร์เดอร์ที่จ่ายครบ',
                            orderPayed.length.toString()),
                        buildOrderList('ออร์เดอร์ที่ปฏิเสธ',
                            orderReject.length.toString()),
                        buildTotalIncome('รวมรายได้ทั้งหมด', orderPrepaid,
                            orderAccept, orderPayed, orderReject),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
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
        return focusIncomeMonth
            ? Theme(
                data: ThemeData.light(),
                child: child!,
              )
            : AlertDialog(
                title: const Text("เลือกปีที่ต้องการดูรายรับ"),
                content: SizedBox(
                  width: 300,
                  height: 300,
                  child: YearPicker(
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                    selectedDate: selectedDate,
                    onChanged: (DateTime dateTime) {
                      Navigator.pop(context);
                      setState(() {
                        selectedDate = dateTime;
                      });
                    },
                  ),
                ),
              );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Row buildTotalIncome(
      String type,
      List<QueryDocumentSnapshot<BookingModel>> prepaids,
      List<QueryDocumentSnapshot<BookingModel>> accepts,
      List<QueryDocumentSnapshot<BookingModel>> payeds,
      List<QueryDocumentSnapshot<BookingModel>> rejects) {
    double totalPrice = calculateTotalPrice(prepaids, accepts, payeds, rejects);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 20),
          child: Text(
            type,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: MyConstant.colorStore,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25.0, top: 15, bottom: 20),
          child: Text(
            '$totalPrice  บาท',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: MyConstant.colorStore,
            ),
          ),
        ),
      ],
    );
  }

  Row buildOrderList(String type, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15, bottom: 12),
          child: Text(
            type,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25.0, top: 15, bottom: 12),
          child: Text(
            '$amount  รายการ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Row buildShowAndSelectDate(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 15, bottom: 12),
          child: Text(
            '${filterDate(selectedDate, type)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        buildSelectDate(width),
      ],
    );
  }

  Row buildFilterDashboard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [buildMonth(), buildYear()],
    );
  }

  Container buildYear() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15),
      child: ElevatedButton(
        child: focusIncomeYear
            ? Text(
                'รายปี',
                style: TextStyle(
                  color: MyConstant.colorStore,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                'รายปี',
                style: TextStyle(color: Colors.grey),
              ),
        onPressed: () {
          setState(() {
            focusIncomeYear = true;
            focusIncomeMonth = false;
            type = 'year';
            selectedDate = DateTime.now();
          });
        },
        style: ElevatedButton.styleFrom(
          primary: focusIncomeYear ? Colors.grey[100] : Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Container buildMonth() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15),
      child: ElevatedButton(
        child: focusIncomeMonth
            ? Text(
                'รายเดือน',
                style: TextStyle(
                  color: MyConstant.colorStore,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                'รายเดือน',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
        onPressed: () {
          setState(() {
            focusIncomeMonth = true;
            focusIncomeYear = false;
            type = 'month';
            selectedDate = DateTime.now();
          });
        },
        style: ElevatedButton.styleFrom(
          primary: focusIncomeMonth ? Colors.grey[100] : Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
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

  Row buildResort(double width, height, String imageRef, restaurantName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: width * 1,
          height: height * 0.28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 1,
                height: height * 0.24,
                child: ShowImageNetwork(
                    pathImage: imageRef,
                    colorImageBlank: MyConstant.colorStore),
              ),
              Text(
                restaurantName,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: MyConstant.colorStore,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
