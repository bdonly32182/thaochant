import 'dart:io';

import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

alertService(BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            openAppSettings();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
