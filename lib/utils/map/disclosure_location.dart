import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

class DisclosureLocation extends StatelessWidget {
  Function goto;
  String message;
  DisclosureLocation({Key? key, required this.goto, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.pin_drop_outlined,
                      color: MyConstant.themeApp,
                      size: 50,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "การใช้งานตำแหน่งของคุณ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: ShowImage(
                  pathImage: MyConstant.currentLocation,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "ไม่ยอมรับ",
                      style: TextStyle(
                        color: MyConstant.themeApp,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(
                        color: MyConstant.themeApp,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => goto(),
                    child: Text("รับทราบ"),
                    style: ElevatedButton.styleFrom(
                      primary: MyConstant.themeApp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
