import 'dart:io';

import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
class CheckoutOrder extends StatefulWidget {
  CheckoutOrder({Key? key}) : super(key: key);

  @override
  State<CheckoutOrder> createState() => _CheckoutOrderState();
}

class _CheckoutOrderState extends State<CheckoutOrder> {
  File? imageSelected;
  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        imageSelected = image;
      });
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        imageSelected = takePhoto;
      });
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
          title: Text('ชำระเงิน'),
        ),
        backgroundColor: MyConstant.backgroudApp,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15),
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
                              'ชื่อร้านอาหาร',
                            ),
                            buildText(
                              width,
                              'ชื่อเจ้าของบัญชี:',
                              'นาย จักรพันธ์ เพียเพ็งต้น',
                            ),
                            buildText(
                              width,
                              'พร้อมเพย์: ',
                              '0814206492',
                            ),
                            buildText(
                              width,
                              'ราคาที่ต้องชำระ:',
                              '330 บาท',
                            ),
                            buildText(
                              width,
                              'วันที่ชำระ:',
                              DateTime.now().toString(),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    // buildQrcode(width, height),
                    buildTextSlip(),
                    buildImage(width)
                  ],
                ),
              ),
            ),
            buildButton(height),
          ],
        ),
      ),
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
        SizedBox(
          height: 15,
          width: width * .2,
          child: IconButton(
            onPressed: getImage,
            icon: Icon(
              Icons.photo_library_rounded,
              color: MyConstant.themeApp,
              size: 40,
            ),
          ),
        ),
        Container(
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
                      color: const Color.fromRGBO(41, 187, 137, 0.7),
                      size: 60,
                    ),
                  ],
                ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
          width: width * .2,
          child: IconButton(
            onPressed: takePhoto,
            icon: Icon(
              Icons.camera_alt_rounded,
              color: MyConstant.themeApp,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  // Row buildQrcode(double width, double height) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         margin: const EdgeInsets.all(10),
  //         width: width * 0.5,
  //         height: height * 0.3,
  //         child: ShowImage(pathImage: 'images/qrcode.png'),
  //       ),
  //     ],
  //   );
  // }

  Row buildText(double width, String typeText, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.26,
          child: Text(
            typeText,
            style: TextStyle(color: Colors.yellow[800]),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0, left: 8.0),
          width: width * 0.5,
          child: Text(text),
        ),
      ],
    );
  }

  Container buildButton(double height) {
    return Container(
      width: double.maxFinite,
      height: height * 0.06,
      child: ElevatedButton(
        child: Text(
          'ยืนยันการชำระเงิน',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          print('send to payment');
        },
        style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
      ),
    );
  }
}