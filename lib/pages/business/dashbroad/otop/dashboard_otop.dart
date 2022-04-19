import 'package:chanthaburi_app/models/order/order.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/resources/firestore/order_product_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardOtop extends StatefulWidget {
  String otopId, imageRef, otopName;
  DashboardOtop(
      {Key? key,
      required this.otopId,
      required this.imageRef,
      required this.otopName})
      : super(key: key);

  @override
  State<DashboardOtop> createState() => _DashboardOtopState();
}

class _DashboardOtopState extends State<DashboardOtop> {
  DateTime selectedDate = DateTime.now();
  List<String> orderCategory = [
    MyConstant.acceptOrder,
    MyConstant.shipping,
    MyConstant.rejected,
    MyConstant.payed,
    MyConstant.received,
    MyConstant.notReceive
  ];
  // _selectDate(BuildContext context) {
  //   final ThemeData theme = Theme.of(context);
  //   switch (theme.platform) {
  //     case TargetPlatform.android:
  //     case TargetPlatform.fuchsia:
  //     case TargetPlatform.linux:
  //     case TargetPlatform.windows:
  //       return buildMaterialDatePicker(context);
  //     case TargetPlatform.iOS:
  //     case TargetPlatform.macOS:
  //       return buildCupertinoDatePicker(context);
  //   }
  // }

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
        DateTime(date.year).millisecondsSinceEpoch,
        DateTime(date.year + 1).millisecondsSinceEpoch,
      ];
    }
    return [
      DateTime(date.year, date.month, 1).millisecondsSinceEpoch,
      DateTime(date.year, date.month + 1, 0).millisecondsSinceEpoch,
    ];
  }

  double calculateTotalPrice(
      List<QueryDocumentSnapshot<OrderModel>> prepaids,
      List<QueryDocumentSnapshot<OrderModel>> accepts,
      List<QueryDocumentSnapshot<OrderModel>> payeds,
      List<QueryDocumentSnapshot<OrderModel>> rejects) {
    double totalPrice = 0;
    for (QueryDocumentSnapshot<OrderModel> prepaid in prepaids) {
      totalPrice += prepaid.data().totalPrice;
    }
    for (QueryDocumentSnapshot<OrderModel> accept in accepts) {
      totalPrice += accept.data().totalPrice;
    }
    for (QueryDocumentSnapshot<OrderModel> payed in payeds) {
      totalPrice += payed.data().totalPrice;
    }
    for (QueryDocumentSnapshot<OrderModel> reject in rejects) {
      totalPrice += reject.data().totalPrice;
    }
    return totalPrice;
  }

  List<Map<String, dynamic>> popularSort(
    List<QueryDocumentSnapshot<OrderModel>> orderShipping,
    List<QueryDocumentSnapshot<OrderModel>> orderReceived,
  ) {
    List<String> foodId = [];
    List<Map<String, dynamic>> popular = [];

    for (QueryDocumentSnapshot<OrderModel> shipping in orderShipping) {
      for (ProductCartModel food in shipping.data().product) {
        if (foodId.contains(food.productId)) {
          int indexDuplicate =
              popular.indexWhere((menu) => menu["productId"] == food.productId);
          popular[indexDuplicate]["score"] =
              popular[indexDuplicate]["score"] + 1;
        } else {
          foodId.add(food.productId);
          popular.add({
            "productId": food.productId,
            "productName": food.productName,
            "imageURL": food.imageURL,
            "score": 1,
          });
        }
      }
    }
    for (QueryDocumentSnapshot<OrderModel> received in orderReceived) {
      for (ProductCartModel food in received.data().product) {
        if (foodId.contains(food.productId)) {
          int indexDuplicate =
              popular.indexWhere((menu) => menu["productId"] == food.productId);
          popular[indexDuplicate]["score"] =
              popular[indexDuplicate]["score"] + 1;
        } else {
          foodId.add(food.productId);
          popular.add({
            "productId": food.productId,
            "productName": food.productName,
            "imageURL": food.imageURL,
            "score": 1,
          });
        }
      }
    }
    popular.sort((a, b) => b["score"].compareTo(a["score"]));
    return popular;
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
              buildOtop(width, height, widget.imageRef, widget.otopName),
              buildFilterDashboard(),
              buildShowAndSelectDate(width),
              StreamBuilder(
                  stream: OrderProductCollection.orderByOtopId(widget.otopId,
                      orderCategory, betweenDate[0], betweenDate[1]),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<OrderModel>> snapshot) {
                    if (snapshot.hasError) {
                      return const InternalError();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const PouringHourGlass();
                    }
                    List<QueryDocumentSnapshot<OrderModel>> orders =
                        snapshot.data!.docs;
                    List<QueryDocumentSnapshot<OrderModel>> orderShipping =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.shipping)
                            .toList();
                    List<QueryDocumentSnapshot<OrderModel>> orderAccept = orders
                        .where((order) =>
                            order.data().status == MyConstant.acceptOrder)
                        .toList();
                    List<QueryDocumentSnapshot<OrderModel>> orderPayed = orders
                        .where(
                            (order) => order.data().status == MyConstant.payed)
                        .toList();
                    List<QueryDocumentSnapshot<OrderModel>> orderReject = orders
                        .where((order) =>
                            order.data().status == MyConstant.rejected)
                        .toList();
                    List<QueryDocumentSnapshot<OrderModel>> orderReceived =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.received)
                            .toList();
                    List<QueryDocumentSnapshot<OrderModel>> orderNotReceived =
                        orders
                            .where((order) =>
                                order.data().status == MyConstant.notReceive)
                            .toList();
                    return Column(
                      children: [
                        buildOrderList(
                          'ออร์เดอร์ที่จ่ายครบ',
                          orderPayed.length.toString(),
                        ),
                        buildOrderList(
                          'ออร์เดอร์ที่อนุมัติ',
                          orderAccept.length.toString(),
                        ),
                        buildOrderList(
                          'ออร์เดอร์จัดส่ง',
                          orderShipping.length.toString(),
                        ),
                        buildOrderList(
                          'ลูกค้าได้รับออร์เดอร์',
                          orderReceived.length.toString(),
                        ),
                        buildOrderList(
                          'ลูกค้าไม่ได้รับออร์เดอร์',
                          orderNotReceived.length.toString(),
                        ),
                        buildOrderList(
                          'ออร์เดอร์ที่ปฏิเสธ',
                          orderReject.length.toString(),
                        ),
                        buildTotalIncome(
                          'รวมรายได้ทั้งหมด',
                          orderShipping,
                          orderAccept,
                          orderPayed,
                          orderReject,
                        ),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "เมนูยอดนิยม",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        buildPopularMenu(
                            width, height, orderShipping, orderReceived)
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildPopularMenu(
    double width,
    double height,
    List<QueryDocumentSnapshot<OrderModel>> orderShipping,
    List<QueryDocumentSnapshot<OrderModel>> orderReceived,
  ) {
    List<Map<String, dynamic>> populars =
        popularSort(orderShipping, orderReceived);
    return SizedBox(
      width: width * 1,
      height: height * 0.2,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: populars.length > 5 ? 5 : populars.length,
        itemBuilder: (itemBuilder, index) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            width: width * 0.34,
            height: height * 0.2,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                  child: ShowImageNetwork(
                    pathImage: populars[index]["imageURL"],
                    colorImageBlank: MyConstant.colorStore,
                  ),
                ),
                Text(populars[index]["productName"]),
              ],
            ),
          );
        },
      ),
    );
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                setState(() {
                  selectedDate = picked;
                });
              },
              initialDateTime: selectedDate,
              minimumYear: 2021,
              maximumYear: 2100,
            ),
          );
        });
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
                content: Container(
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
      List<QueryDocumentSnapshot<OrderModel>> prepaids,
      List<QueryDocumentSnapshot<OrderModel>> accepts,
      List<QueryDocumentSnapshot<OrderModel>> payeds,
      List<QueryDocumentSnapshot<OrderModel>> rejects) {
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
      margin: const EdgeInsets.only(top: 10, left: 15),
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
      margin: const EdgeInsets.only(top: 10, left: 15),
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

  Row buildOtop(double width, height, String imageRef, otopName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: width * 1,
          height: height * 0.24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 1,
                height: height * 0.2,
                child: ShowImageNetwork(
                  pathImage: imageRef,
                  colorImageBlank: MyConstant.colorStore,
                ),
              ),
              Text(
                otopName,
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
