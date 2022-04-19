import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

dialogConfirm(
    BuildContext context, String title, String message, Function onOk) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: ShowImage(
          pathImage: MyConstant.notifyImage,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  onOk(context);
                  // Navigator.pop(context);
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shadowColor: MyConstant.backgroudApp,
                  side: BorderSide(
                    color: MyConstant.themeApp,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shadowColor: MyConstant.backgroudApp,
                  side: BorderSide(
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

dialogCamera(BuildContext context, Function getImage, Function takePhoto,
    Color myColor) {
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return SizedBox(
        height: 180,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 55,
              child: TextButton(
                onPressed: () {
                  getImage();
                  Navigator.pop(context);
                },
                child: Text(
                  'แกลออรี่',
                  style: TextStyle(
                    fontSize: 18,
                    color: myColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 0.4),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 55,
              child: TextButton(
                onPressed: () {
                  takePhoto();
                  Navigator.pop(context);
                },
                child: Text(
                  'ถ่ายรูป',
                  style: TextStyle(
                    fontSize: 18,
                    color: myColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 0.4),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 60,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontSize: 18,
                    color: myColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
  );
}

dialogAddress(
  BuildContext context,
  Function changeAddress,
  Function editAddress,
  ShippingModel address,
  String docId,
  bool isCurrent,
  Color myColor,
) {
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return SizedBox(
        height: 130,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 55,
              child: TextButton(
                onPressed: () {
                  changeAddress(address);
                  Navigator.pop(context);
                },
                child: Text(
                  'เปลี่ยนที่อยู่',
                  style: TextStyle(
                    fontSize: 18,
                    color: myColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 0.4),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 55,
              child: TextButton(
                onPressed: () {
                  editAddress(context, address, docId, isCurrent);
                },
                child: Text(
                  'แก้ไขข้อมูล',
                  style: TextStyle(
                    fontSize: 18,
                    color: myColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 0.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
