import 'package:chanthaburi_app/models/order/order.dart';
import 'package:chanthaburi_app/resources/firestore/order_product_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderProductDetail extends StatefulWidget {
  QueryDocumentSnapshot<OrderModel> order;
  OrderProductDetail({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderProductDetail> createState() => _OrderProductDetailState();
}

class _OrderProductDetailState extends State<OrderProductDetail> {
  String onChangeCategory = "ALL";
  List<DropdownMenuItem<String>> items = [
    "ALL",
    MyConstant.acceptOrder,
    MyConstant.payed,
    MyConstant.rejected,
    MyConstant.shipping,
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
        await OrderProductCollection.changeStatus(orderId, status, recipientId);
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
            buildOrderStatus(widget.order["status"]),
            cardDetail(
              width,
              widget.order["addressInfo"]["fullName"],
              widget.order["addressInfo"]["phoneNumber"],
              widget.order["product"].length,
              widget.order["totalPrice"],
            ),
            buildSlipword(),
            buildSlipImage(width, height, widget.order["imagePayment"]),
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
        color: MyConstant.colorStore,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container cardDetail(double width, String fullName, phoneNumber,
      int amountProduct, double totalPrice) {
    return Container(
      width: width * .8,
      child: Column(
        children: [
          const SizedBox(height: 15),
          buildField("ชื่อผู้สั่งซื้อ :", fullName),
          buildField("เบอร์โทรติดต่อ :", phoneNumber),
          buildField("จำนวนสินค้า :", "$amountProduct รายการ"),
          buildField("ราคา :", "$totalPrice บาท"),
          buildShippingAddress(width, widget.order.data().addressInfo.address),
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
                widget.order.id,
                widget.order.data().userId,
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
            style: TextStyle(
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

  Card buildShippingAddress(double width, String address) {
    return Card(
      margin: const EdgeInsets.all(5),
      color: Colors.grey[200],
      child: Row(
        children: [
          Text(
            'ที่อยู่ในการจัดส่ง : ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              address,
              style: TextStyle(
                color: MyConstant.colorStore,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.fade,
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
          width: width * 0.8,
          height: height * 0.4,
          child: ShowImageNetwork(
            pathImage: imagePayment,
            colorImageBlank: MyConstant.colorStore,
          ),
        )
      ],
    );
  }
}
