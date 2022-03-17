import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class ResponseDialog extends StatelessWidget {
  final Map<String, dynamic> response;
  const ResponseDialog({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> status = {
      "400": {
        "icon": Icons.close,
        "color": Colors.red,
      },
      "200": {
        "icon": Icons.check,
        "color": MyConstant.themeApp,
      },
      "199": {
        "icon": Icons.warning_amber_rounded,
        "color": Colors.amber[800],
      }
    };
    return AlertDialog(
      content: SizedBox(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              width: 60,
              height: 60,
              child: Icon(
                status[response["status"]]!["icon"],
                color: Colors.white,
                size: 60,
              ),
              decoration: BoxDecoration(
                color: status[response["status"]]!["color"],
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Text(
              response["message"],
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
