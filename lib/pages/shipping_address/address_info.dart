import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/pages/shipping_address/create_shipping_address.dart';
import 'package:chanthaburi_app/pages/shipping_address/shipping_adress.dart';
import 'package:chanthaburi_app/resources/firestore/shipping_address_collection.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressInfo extends StatefulWidget {
  List<ShippingModel> address;
  String userId;
  AddressInfo({Key? key, required this.address, required this.userId})
      : super(key: key);

  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot<ShippingModel>>(
        stream: ShippingAddressCollection.myAddress(widget.userId),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<ShippingModel>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("ขออภัย เกิดเหตุขัดข้อง ณ ขณะนี้"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          int totalAddress = snapshot.data!.docs.length;
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) =>
                        widget.address.isEmpty && totalAddress == 0
                            ? CreateShippingAddress(
                                isNewAddress: true,
                              )
                            : ShippingAddress(),
                  ),
                );
              },
              child: widget.address.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          width: width * 0.9,
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: const [
                              Icon(Icons.contact_mail_outlined),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('ข้อมูลการติดต่อ'),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.7,
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            children: [
                              Text(widget.address[0].fullName),
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text('|'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(widget.address[0].phoneNumber),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: width * 0.7,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.address[0].address,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'ไม่มีข้อมูลติดต่อ',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            totalAddress == 0
                                ? 'สร้างข้อมูลติดต่อ'
                                : "เลือกที่อยู่อื่นๆ",
                            style: const TextStyle(color: Colors.red),
                          ),
                          const Text(
                            'คลิ๊ก',
                            style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}
