import 'package:flutter/material.dart';

class ImageBlank extends StatelessWidget {
  Color imageColor;
  ImageBlank({Key? key, required this.imageColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.18,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: imageColor,
              size: 60,
            ),
            const Text("ไม่มีรูปภาพ"),
          ],
        ),
      ),
    );
  }
}
