import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

dialogConfirm(
    BuildContext context, String title, String message, Function onOk) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(title),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(message)],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  onOk();
                  // Navigator.pop(context);
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shadowColor: MyConstant.backgroudApp,
                  side: BorderSide(
                    color: MyConstant.themeApp,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shadowColor: MyConstant.backgroudApp,
                  side: BorderSide(
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

// dialogLoading(BuildContext context, String title) {
//   showDialog(context: context, builder: builder)
// }