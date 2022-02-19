import 'package:flutter/material.dart';
class ModalCategoryImage extends StatelessWidget {
  const ModalCategoryImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(child: Text('กล้องถ่ายรูป'),onPressed: (){
          print('go to camera');
        },),
      ),
      SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(child: Text('แกลอรี่'),onPressed: (){
          print('go to garally');
        },),
      ),
    ],);
  }
}