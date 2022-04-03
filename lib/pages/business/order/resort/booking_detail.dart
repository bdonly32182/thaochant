import 'package:chanthaburi_app/models/booking/booking.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingDetail extends StatefulWidget {
  QueryDocumentSnapshot<BookingModel> booking;
  BookingDetail({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  String onChangeCategory = "ALL";
  List<DropdownMenuItem<String>> items = [
    "ALL",
    MyConstant.acceptOrder,
    MyConstant.payed,
    MyConstant.rejected,
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value == "ALL"
            ? "เลือกหมวดหมู่"
            : MyConstant.statusColor[value]!["text"],
        style: TextStyle(
            color: value == "ALL"
                ? MyConstant.colorStore
                : MyConstant.statusColor[value]!["color"],
            fontSize: 14),
      ),
    );
  }).toList();

  onChangeStatusOrder(String orderId, status, recipientId) async {
    try {
      if (status != "ALL") {
        String statusText = MyConstant.statusColor[status]!["text"];
        await BookingCollection.changeStatus(orderId, status, recipientId);
        dialogAlert(context, "อัพเดทสถานะ",
            "อัพเดทสถานะออร์เดอร์เป็น $statusText เรียบร้อย");
      } else {
        dialogAlert(context, "แจ้งเตือน", "กรุณาเลือกสถานะ");
      }
    } catch (e) {
      dialogAlert(context, "อัพเดทสถานะ", "เกิดเหตุขัดข้อง อัพเดทสถานะล้มเหลว");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดออร์เดอร์"),
        backgroundColor: MyConstant.colorStore,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildOrderStatus(widget.booking["status"]),
            cardDetail(
              width,
              widget.booking["addressInfo"]["fullName"],
              widget.booking["addressInfo"]["phoneNumber"],
              widget.booking["totalRoom"],
              widget.booking["prepaidPrice"],
            ),
            buildSlipword(),
            buildSlipImage(width, height, widget.booking["imagePayment"]),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Container buildSlipword() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'ใบเสร็จรับเงิน',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
        ),
      ),
      decoration: BoxDecoration(
        color: MyConstant.themeApp,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container cardDetail(double width, String fullName, phoneNumber,
      int amountFoods, double prepaidPrice) {
    return Container(
      width: width * .8,
      child: Column(
        children: [
          const SizedBox(height: 15),
          buildField("ชื่อผู้สั่งซื้อ :", fullName),
          buildField("เบอร์โทรติดต่อ :", phoneNumber),
          buildField("จำนวนห้องพัก :", "$amountFoods ห้อง"),
          buildField("ราคา :", "$prepaidPrice บาท"),
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
                    style: TextStyle(color: MyConstant.themeApp),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              confirmButton(
                onChangeCategory,
                "เปลี่ยนแปลงสถานะ",
                widget.booking.id,
                widget.booking["userId"],
                MyConstant.colorStore,
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container confirmButton(
      String status, title, orderId, recipientId, Color colorStyle) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        child: Text(
          title,
          style: TextStyle(fontSize: 20, color: colorStyle),
        ),
        onPressed: () => onChangeStatusOrder(orderId, status, recipientId),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          side: BorderSide(
            color: colorStyle,
          ),
        ),
      ),
    );
  }

  Container buildField(String title, String text) {
    return Container(
      height: 35,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            text,
            style:  TextStyle(
              color: MyConstant.colorStore,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Card buildOption(double width, List<dynamic> products) {
    return Card(
      margin: const EdgeInsets.all(5),
      color: Colors.grey[200],
      child: Row(
        children: [
          Text(
            'เพิ่มเติม : ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 4),
            height: 90,
            width: width * .5,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: products[index]["addtionMessage"] != ""
                      ? [
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 16,
                                color: Colors.blue,
                              ),
                              Text(
                                products[index]["productName"],
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "- ${products[index]["addtionMessage"]}",
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 3,
                          ),
                        ]
                      : [],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildOrderStatus(String status) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          MyConstant.statusColor[status]!["text"],
          style: TextStyle(
            color: MyConstant.statusColor[status]!["color"],
            fontSize: 17,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Row buildSlipImage(double width, double height, String imagePayment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          width: width * .7,
          height: height * .3,
          child: ShowImageNetwork(
            pathImage: imagePayment,
            colorImageBlank: MyConstant.colorStore,
          ),
        )
      ],
    );
  }
}
