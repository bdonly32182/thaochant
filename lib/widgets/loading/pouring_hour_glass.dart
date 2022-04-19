import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PouringHourGlass extends StatelessWidget {
  const PouringHourGlass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SpinKitPouringHourGlass(
              duration: Duration(milliseconds: 1000),
              strokeWidth: 2,
              color: Color.fromRGBO(245, 182, 91, 1),
            ),
            Text("กรุณารอสักครู่...")
          ],
        ),
      ),
    );
  }
}
