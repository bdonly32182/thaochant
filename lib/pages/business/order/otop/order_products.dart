import 'package:chanthaburi_app/models/order/order.dart';
import 'package:chanthaburi_app/pages/business/order/otop/order_otop_detail.dart';
import 'package:chanthaburi_app/resources/firestore/order_product_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class OrderProducts extends StatefulWidget {
  String otopId;
  OrderProducts({Key? key, required this.otopId}) : super(key: key);

  @override
  State<OrderProducts> createState() => _OrderProductsState();
}

class _OrderProductsState extends State<OrderProducts> {
  List<String> orderCategory = [
    MyConstant.acceptOrder,
    MyConstant.rejected,
    MyConstant.payed,
    MyConstant.shipping,
  ];
  String onChangeCategory = "ALL";
  DateTime now = DateTime.now();
  int? dateCreate;
  int? endDate;
  int onChangeDate = DateTime.now().millisecondsSinceEpoch;
  int onChangeEndDate =
      DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch;
  bool isFilter = false;
  List<DropdownMenuItem<String>> items = [
    "ALL",
    MyConstant.acceptOrder,
    MyConstant.rejected,
    MyConstant.payed,
    MyConstant.shipping,
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value == "ALL" ? "ทั้งหมด" : MyConstant.statusColor[value]!["text"],
        style: TextStyle(
            color: value == "ALL"
                ? MyConstant.colorStore
                : MyConstant.statusColor[value]!["color"],
            fontSize: 14),
      ),
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    setState(() {
      dateCreate = DateTime(now.year, now.month, now.day)
          .add(const Duration(hours: 0))
          .millisecondsSinceEpoch;
      endDate = DateTime(now.year, now.month, now.day)
          .add(const Duration(hours: 24))
          .millisecondsSinceEpoch;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyConstant.colorStore,
        title: Text(isFilter ? "คัดกรองออร์เดอร์" : "ออร์เดอร์สินค้า"),
        actions: isFilter
            ? [
                IconButton(
                  onPressed: () => setState(() {
                    isFilter = false;
                    onChangeCategory = "ALL";
                  }),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFilter = true;
                    });
                  },
                  icon: const Icon(
                    Icons.filter_list_alt,
                  ),
                ),
              ],
      ),
      body: isFilter
          ? buildFilterCategory(width)
          : buildStreamOrders(width, height),
    );
  }

  StreamBuilder<QuerySnapshot<OrderModel>> buildStreamOrders(
      double width, double height) {
    return StreamBuilder(
        stream: OrderProductCollection.orderByOtopId(
            widget.otopId, orderCategory, dateCreate!, endDate!),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<OrderModel>> orderSnapshot) {
          if (orderSnapshot.hasError) {
            return const InternalError();
          }
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          List<QueryDocumentSnapshot<OrderModel>> orders =
              orderSnapshot.data!.docs;
          if (orders.isEmpty) {
            return const Center(child: ShowDataEmpty());
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderProductDetail(order: orders[index]),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: width * .92,
                      height: height * .2,
                      child: Row(
                        children: [
                          buildDetail(
                            width,
                            index,
                            orders[index]["addressInfo"]["fullName"],
                            orders[index]["totalPrice"],
                            orders[index]["product"].length,
                            orders[index]["status"],
                            orders[index]["dateCreate"],
                          ),
                          buildImagePayment(
                              width, orders[index]["imagePayment"]),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  Column buildFilterCategory(double width) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: width * .5,
              height: 60,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: items,
                  style: TextStyle(color: MyConstant.colorStore),
                  onChanged: (String? value) => setState(() {
                    onChangeCategory = value!;
                  }),
                  value: onChangeCategory,
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Colors.white)],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .5,
          child: DateTimePicker(
            dateHintText: '${DateTime.fromMillisecondsSinceEpoch(dateCreate!)}',
            firstDate: DateTime(2022),
            lastDate: DateTime(2100),
            onChanged: (val) {
              setState(() {
                DateTime dateTime = DateTime.parse(val);
                DateTime newDay = DateTime.parse(val)
                    .add(Duration(hours: dateTime.hour + 24));

                onChangeDate = dateTime.millisecondsSinceEpoch;
                onChangeEndDate = newDay.millisecondsSinceEpoch;
              });
            },
            style: TextStyle(
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .34,
          child: ElevatedButton(
            child: const Text("ค้นหา"),
            onPressed: () {
              setState(() {
                isFilter = false;
                if (onChangeCategory == "ALL") {
                  orderCategory = [
                    MyConstant.acceptOrder,
                    MyConstant.rejected,
                    MyConstant.payed,
                    MyConstant.shipping
                  ];
                } else {
                  orderCategory = [onChangeCategory];
                }
                dateCreate = onChangeDate;
                endDate = onChangeEndDate;
              });
            },
            style: ElevatedButton.styleFrom(primary: MyConstant.colorStore),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  SizedBox buildDetail(double width, int index, String fullName,
      double totalPrice, int amountFoods, String status, int dateMilSec) {
    DateTime createOrder = DateTime.fromMillisecondsSinceEpoch(dateMilSec);
    return SizedBox(
      width: width * .64,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                child: const Icon(
                  Icons.list_sharp,
                  color: Colors.black54,
                ),
                margin: const EdgeInsets.only(left: 10, right: 5),
              ),
              Text(
                fullName,
                style: TextStyle(
                  color: MyConstant.colorStore,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: const Icon(
                  Icons.attach_money_outlined,
                  color: Colors.black54,
                ),
                margin: const EdgeInsets.all(7),
              ),
              Text(
                "$totalPrice บาท",
                style: TextStyle(
                  color: MyConstant.colorStore,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: const Icon(
                  Icons.food_bank_outlined,
                  color: Colors.black54,
                ),
                margin: const EdgeInsets.all(7),
              ),
              Text(
                "$amountFoods รายการ",
                style: TextStyle(
                  color: MyConstant.colorStore,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                margin: const EdgeInsets.all(7),
              ),
              Text(
                "วันที่ ${createOrder.day} ${MyConstant.monthThailand[createOrder.month - 1]} ${createOrder.year}",
                style: TextStyle(
                  color: MyConstant.colorStore,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                MyConstant.statusColor[status]!["text"],
                style:
                    TextStyle(color: MyConstant.statusColor[status]!["color"]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildImagePayment(double width, String imagePayment) {
    return Container(
      width: width * .26,
      height: 130,
      child: ShowImageNetwork(
        colorImageBlank: MyConstant.colorStore,
        pathImage: imagePayment,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    );
  }
}
