import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

dialogLogin(
    BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: ShowImage(
          pathImage: MyConstant.notifyImage,
        ),
        title: const Text(
          "ล็อกอิน",
          style: TextStyle(fontSize: 18),
        ),
        subtitle: const Text(
          "ไม่สามารถใช้บริการได้เนื่องจากท่านยังไม่ได้เข้าสู่ระบบ กรุณาเข้าสู่ระบบ",
          style: TextStyle(fontSize: 14),
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
                  Navigator.pushNamedAndRemoveUntil(context, '/authen', (route) => false);
                },
                child: Text(
                  'เข้าสู่ระบบ',
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