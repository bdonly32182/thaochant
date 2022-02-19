import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

import '../show_image.dart';
class SearchResultFound extends StatelessWidget {
  const SearchResultFound({Key? key}) : super(key: key);

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
              child: ShowImage(pathImage: MyConstant.search),
            ),
            const Text(
              "ค้นหาด้วยคำอื่น?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Text(
              "ไม่พบผลลัพท์ที่คุณค้นหา",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}