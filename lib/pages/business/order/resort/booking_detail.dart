import 'package:chanthaburi_app/models/booking/booking.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingDetail extends StatefulWidget {
  bool isOwner;
  QueryDocumentSnapshot<BookingModel> booking;
  BookingDetail({Key? key, required this.booking, required this.isOwner})
      : super(key: key);

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  String? onChangeCategory;
  List<DropdownMenuItem<String>> items = [
    MyConstant.acceptOrder,
    MyConstant.payed,
    MyConstant.rejected,
    MyConstant.prepaidStatus,
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        MyConstant.statusColor[value]!["text"],
        style: TextStyle(
            color: MyConstant.statusColor[value]!["color"], fontSize: 14),
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
  void initState() {
    super.initState();
    setState(() {
      onChangeCategory = widget.booking.data().status;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดออร์เดอร์"),
        backgroundColor:
            widget.isOwner ? MyConstant.colorStore : MyConstant.themeApp,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(child: buildField("รหัสการสั่งซื้อ : ", widget.booking.id)),
            Card(
              child: cardDetail(
                width,
                widget.booking["addressInfo"]["fullName"],
                widget.booking["addressInfo"]["phoneNumber"],
                widget.booking["addressInfo"]["address"],
                widget.booking["prepaidPrice"],
                widget.booking.data().totalRoom,
                widget.booking.data().roomId,
              ),
            ),
            buildCardStatus(width),
            buildSlipword(),
            buildSlipImage(width, height, widget.booking["imagePayment"]),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Card buildCardStatus(double width) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: widget.isOwner ? width * 0.4 : width * 0.8,
                margin: const EdgeInsets.all(14),
                child: widget.isOwner
                    ? DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: items,
                          style: TextStyle(color: MyConstant.themeApp),
                          onChanged: (String? value) => setState(() {
                            onChangeCategory = value!;
                          }),
                          value: onChangeCategory,
                        ),
                      )
                    : Text(
                        "สถานะ : ${MyConstant.statusColor[onChangeCategory]!["text"]}",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyConstant.themeApp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.white)],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          confirmButton(
            onChangeCategory!,
            "อัพเดทสถานะ",
            widget.booking.id,
            widget.booking.data().userId,
            MyConstant.colorStore,
          ),
        ],
      ),
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
        color: widget.isOwner ? MyConstant.colorStore : MyConstant.themeApp,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container cardDetail(double width, String fullName, phoneNumber,
      String address, num prepaidPrice, int totalRoom, String roomId) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          const SizedBox(height: 15),
          buildField("ชื่อผู้สั่งซื้อ :", fullName),
          buildField("เบอร์โทรติดต่อ :", phoneNumber),
          buildField("ที่อยู่ : ", address),
          buildField("ราคา : ", "฿ $prepaidPrice บาท"),
          FutureBuilder(
            future: RoomCollection.roomById(roomId),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('เกิดเหตุขัดข้อง');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading ...');
              }
              return buildField(
                  "ชื่อห้องพัก : ", " ${snapshot.data!.get("roomName")}");
            },
          ),
          buildField("จำนวนห้องพัก : ", "$totalRoom ห้อง"),
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
      margin: const EdgeInsets.only(right: 10),
      child: widget.isOwner
          ? ElevatedButton(
              child: Text(
                title,
                style: TextStyle(fontSize: 20, color: colorStyle),
              ),
              onPressed: () =>
                  onChangeStatusOrder(orderId, status, recipientId),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(
                  color: colorStyle,
                ),
              ),
            )
          : null,
    );
  }

  Container buildField(String title, String text) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: double.maxFinite,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: widget.isOwner
                    ? MyConstant.colorStore
                    : MyConstant.themeApp,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

  // Card buildMenuList(
  //     double width, List<ProductCartModel> products, num totalPrice) {
  //   return Card(
  //     margin: const EdgeInsets.only(
  //       top: 10,
  //       left: 30,
  //       right: 30,
  //     ),
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("รายการและรายละเอียดอาหาร"),
  //         ),
  //         Container(
  //           margin: const EdgeInsets.all(10.0),
  //           width: double.maxFinite,
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             physics: const ScrollPhysics(),
  //             itemCount: products.length,
  //             itemBuilder: (BuildContext context, index) {
  //               return Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text("x ${products[index].amount}"),
  //                       Container(
  //                         margin: const EdgeInsets.only(left: 12, top: 10),
  //                         width: width * 0.6,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               products[index].productName,
  //                               softWrap: true,
  //                               maxLines: 2,
  //                             ),
  //                             Text("- ${products[index].addtionMessage}")
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       products[index].totalPrice.toString(),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Text(
  //                 "ทั้งหมด",
  //                 style: TextStyle(
  //                   color: widget.isOwner
  //                       ? MyConstant.colorStore
  //                       : MyConstant.themeApp,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Text(
  //                 "฿ $totalPrice",
  //                 style: TextStyle(
  //                   color: widget.isOwner
  //                       ? MyConstant.colorStore
  //                       : MyConstant.themeApp,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

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
