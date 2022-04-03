import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

class ResponseDialog extends StatelessWidget {
  final Map<String, dynamic> response;
  const ResponseDialog({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        leading: ShowImage(
          pathImage: MyConstant.notifyImage,
        ),
        title: const Text(
          "แจ้งเตือน",
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          response["message"],
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
