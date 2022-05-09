import 'package:chanthaburi_app/pages/business/menu/otop/edit_menu_otop.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CardMenuOtop extends StatefulWidget {
  final String imageRef, productName, price, productId, otopId;
  final int status;
  CardMenuOtop({
    Key? key,
    required this.imageRef,
    required this.price,
    required this.productName,
    required this.productId,
    required this.otopId,
    required this.status,
  }) : super(key: key);

  @override
  State<CardMenuOtop> createState() => _CardMenuOtopState();
}

class _CardMenuOtopState extends State<CardMenuOtop> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => EditMenuOtop(
                    otopId: widget.otopId,
                    productId: widget.productId,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                  height: 60,
                  child: widget.imageRef.isNotEmpty
                      ? Image.network(
                          widget.imageRef,
                          fit: BoxFit.fitWidth,
                          width: width * 0.16,
                          errorBuilder: (BuildContext buildImageError, object,
                              stackthree) {
                            return SizedBox(
                              width: width * 0.16,
                              child: const Icon(Icons.food_bank),
                            );
                          },
                        )
                      : SizedBox(
                          width: width * 0.16,
                          child: const Icon(Icons.food_bank),
                        ),
                ),
                SizedBox(
                  width: width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.productName,
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      Text(widget.price.toString()),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.3,
                  margin: const EdgeInsets.only(left: 6),
                  child: ToggleSwitch(
                    totalSwitches: 2,
                    minWidth: 50.0,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [Colors.red.shade600],
                      [MyConstant.colorStore],
                    ],
                    labels: const ['หมด', 'ขาย'],
                    activeFgColor: Colors.white,
                    inactiveBgColor: MyConstant.backgroudApp,
                    inactiveFgColor: Colors.grey,
                    initialLabelIndex: widget.status,
                    radiusStyle: true,
                    onToggle: (index) {
                      if (widget.status != index) {
                        ProductOtopCollection.changeStatusProduct(
                            widget.productId, index!);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
