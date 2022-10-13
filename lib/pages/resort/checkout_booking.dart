import 'dart:io';

import 'package:chanthaburi_app/models/booking/booking.dart';
import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/provider/participant_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CheckoutBooking extends StatefulWidget {
  String businessId, roomId;
  ShippingModel address;
  num totalPrice;
  num prepaidPrice;
  int checkIn, checkOut, totalSelectRoom;

  CheckoutBooking({
    Key? key,
    required this.businessId,
    required this.address,
    required this.totalPrice,
    required this.prepaidPrice,
    required this.checkIn,
    required this.checkOut,
    required this.roomId,
    required this.totalSelectRoom,
  }) : super(key: key);

  @override
  State<CheckoutBooking> createState() => _CheckoutBookingState();
}

class _CheckoutBookingState extends State<CheckoutBooking> {
  File? imageSelected;
  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        imageSelected = image;
      });
    } else {
      PermissionStatus cameraStatus = await Permission.photos.status;
      if (cameraStatus.isPermanentlyDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Photo',
          'โปรดแชร์ Photo',
        );
      }
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        imageSelected = takePhoto;
      });
    } else {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (cameraStatus.isPermanentlyDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Camera',
          'โปรดแชร์ Camera',
        );
      }
    }
  }

  onSubmit() async {
    late BuildContext dialogContext;
    if (imageSelected != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );

      BookingModel bookingModel = BookingModel(
        userId: AuthMethods.currentUser(),
        addressInfo: widget.address,
        totalPrice: widget.totalPrice,
        prepaidPrice: widget.prepaidPrice,
        imagePayment: '',
        dateCreate: DateTime.now(),
        resortId: widget.businessId,
        status: MyConstant.prepaidStatus,
        roomId: widget.roomId,
        reviewed: false,
        checkIn: DateTime.fromMillisecondsSinceEpoch(widget.checkIn),
        checkOut: DateTime.fromMillisecondsSinceEpoch(widget.checkOut),
        totalRoom: widget.totalSelectRoom,
      );
      Map<String, dynamic> response =
          await BookingCollection.createBooking(bookingModel, imageSelected!);
      var participant =
          Provider.of<ParticipantProvider>(context, listen: false);
      participant.reserveRoom(widget.businessId, widget.totalSelectRoom);
      Navigator.pop(dialogContext);
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(
          response: {
            "status": "199",
            "message": "กรุณาแนบรูปภาพการชำระเงิน",
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.themeApp,
          title: const Text('ชำระเงิน'),
        ),
        backgroundColor: MyConstant.backgroudApp,
        body: FutureBuilder(
            future: ResortCollection.resortById(widget.businessId),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<BusinessModel>> snapshot) {
              if (snapshot.hasError) {
                return const InternalError();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PouringHourGlass();
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            width: width * 0.9,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  buildText(
                                    width,
                                    'ชื่อร้าน:',
                                    snapshot.data!.get("businessName"),
                                  ),
                                  FutureBuilder(
                                      future: UserCollection.userById(
                                          snapshot.data!.get("sellerId")),
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshotUser) {
                                        if (snapshotUser.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text('loading ...');
                                        }
                                        return buildText(
                                          width,
                                          'ชื่อเจ้าของบัญชี:',
                                          snapshotUser.data!.get("fullName"),
                                        );
                                      }),
                                  buildTypePayment(width, snapshot),
                                  buildPromptpay(width,
                                      snapshot.data!.get("paymentNumber")),
                                  buildText(
                                    width,
                                    'ราคาที่ต้องชำระ:',
                                    "${widget.prepaidPrice} ฿",
                                  ),
                                  buildText(
                                    width,
                                    'วันที่ชำระ:',
                                    DateTime.now().toString(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                          buildQrcode(
                            width,
                            height,
                            snapshot.data!.get("paymentNumber"),
                            widget.prepaidPrice,
                            snapshot.data!.get("qrcodeRef"),
                          ),
                          buildTextSlip(),
                          buildImage(width)
                        ],
                      ),
                    ),
                  ),
                  buildButton(height),
                ],
              );
            }),
      ),
    );
  }

  Row buildTypePayment(
      double width, AsyncSnapshot<DocumentSnapshot<BusinessModel>> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.26,
          child: Text(
            'ธนาคาร/พร้อมเพย์: ',
            style: TextStyle(color: Colors.yellow[800]),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.4,
          child: Text(snapshot.data!.data()!.typePayment),
        ),
      ],
    );
  }

  Row buildPromptpay(double width, String promptPay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.26,
          child: Text(
            'เลขบัญชี: ',
            style: TextStyle(color: Colors.yellow[800]),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.4,
          child: Text(promptPay),
        ),
        SizedBox(
          width: width * 0.1,
          child: IconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: promptPay),
              );
              dialogAlert(context, "แจ้งเตือน", "คัดลอกเรียบร้อย");
            },
            icon: const Icon(
              Icons.copy,
            ),
          ),
        )
      ],
    );
  }

  Row buildTextSlip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'หลักฐานการชำระเงิน',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyConstant.themeApp,
            ),
          ),
        )
      ],
    );
  }

  Row buildImage(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () =>
              dialogCamera(context, getImage, takePhoto, MyConstant.themeApp),
          child: Container(
            width: width * .6,
            height: 150,
            child: imageSelected != null
                ? Image.file(
                    imageSelected!,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.image,
                        color: Color.fromRGBO(41, 187, 137, 0.7),
                        size: 60,
                      ),
                    ],
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column buildQrcode(double width, double height, String promptPay,
      num prepaidPrice, String qrcodeRef) {
    return Column(
        children: qrcodeRef.isNotEmpty
            ? [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'คิวอาร์โค้ดของทางบ้านพัก]',
                        style: TextStyle(
                          color: MyConstant.themeApp,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      height: height * 0.3,
                      child: ShowImageNetwork(
                        colorImageBlank: MyConstant.themeApp,
                        pathImage: qrcodeRef,
                      ),
                    ),
                  ],
                ),
              ]
            : [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: width * 0.76,
                      height: height * 0.1,
                      child: ShowImage(
                        pathImage: MyConstant.promptPayImage,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By QR Mango',
                      style: TextStyle(
                        color: MyConstant.themeApp,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      height: height * 0.3,
                      child: ShowImageNetwork(
                        colorImageBlank: MyConstant.themeApp,
                        pathImage:
                            'https://qrmango.com/promptpay/qr?pp_no=$promptPay&amount=$prepaidPrice',
                      ),
                    ),
                  ],
                ),
              ]);
  }

  Row buildText(double width, String typeText, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.26,
          child: Text(
            typeText,
            style: TextStyle(color: Colors.yellow[800]),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.5,
          child: Text(text),
        ),
      ],
    );
  }

  SizedBox buildButton(double height) {
    return SizedBox(
      width: double.maxFinite,
      height: height * 0.06,
      child: ElevatedButton(
        child: const Text(
          'ยืนยันการชำระเงิน',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
      ),
    );
  }
}
