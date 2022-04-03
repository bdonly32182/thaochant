import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

dialogAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: ListTile(
        leading: ShowImage(
          pathImage: MyConstant.notifyImage,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ),
  );
}
