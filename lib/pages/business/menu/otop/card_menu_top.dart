import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CardMenuOtop extends StatefulWidget {
  final String imageRef, productName, price;
  CardMenuOtop({
    Key? key,
    required this.imageRef,
    required this.price,
    required this.productName,
  }) : super(key: key);

  @override
  State<CardMenuOtop> createState() => _CardMenuOtopState();
}

class _CardMenuOtopState extends State<CardMenuOtop> {
  String showImageRef = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setImage();
  }

  void setImage() async {
    if (showImageRef.isEmpty) {
      String? linkImage = await StorageFirebase.showProfileRef(widget.imageRef);
      if (linkImage != null) {
        setState(() {
          showImageRef = linkImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            print('to edit product otop');
          },
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                height: 60,
                child: Image.network(
                  showImageRef,
                  fit: BoxFit.fitWidth,
                  width: width * 0.16,
                  errorBuilder:
                      (BuildContext buildImageError, object, stackthree) {
                    return const Icon(Icons.food_bank);
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(widget.productName),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  Text(widget.price),
                ],
              ),
            ],
          ),
        ),
        ToggleSwitch(
          totalSwitches: 2,
          minWidth: 50.0,
          cornerRadius: 20.0,
          activeBgColors: [
            [Colors.red.shade600],
            [MyConstant.colorStore],
          ],
          labels: ['หมด', 'ขาย'],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          initialLabelIndex: 1,
          radiusStyle: true,
          // onToggle: (index) {
          //   setState(() {
          //     toggleStatus = index;
          //   });
          // },
        ),
      ],
    );
  }
}
