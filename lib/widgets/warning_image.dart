import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class WaringImage extends StatelessWidget {
  const WaringImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            width: width * 0.28,
            height: 80,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: MyConstant.colorStore,
                    size: 60,
                  ),
                  const Text("รูปภาพสินค้า"),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2,
                  offset: Offset(0.2, 0.2),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: width * 0.6,
            child: Column(
              children: const [
                Text(
                  "คำแนะนำ",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "แนะนำให้ใส่รูปภาพสินค้า",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                Text(
                  "อาจมีผลต่อการสุ่มสินค้าขึ้นมาโชว์",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
