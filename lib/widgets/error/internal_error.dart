import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

import '../show_image.dart';

class InternalError extends StatelessWidget {
  const InternalError({Key? key}) : super(key: key);

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
              child: ShowImage(pathImage: MyConstant.internalError),
            ),
            const Text(
              "ขณะนี้เกิดเหตุขัดข้อง",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Text(
              "ขออภัยในความไม่ดวก",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
