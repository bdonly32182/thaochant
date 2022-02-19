import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

import '../show_image.dart';

class BadRequestError extends StatelessWidget {
  const BadRequestError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.6,
              height: size.height * 0.3,
              child: ShowImage(pathImage: MyConstant.badRequestError),
            ),
            const Text(
              "เกิดข้อผิดพลาด",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Text(
              "กรุณาลองใหม่อีกครั้ง",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Container(
              width: size.width * 0.4,
              height: 50,
              margin: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "ย้อนกลับ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: MyConstant.themeApp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
