import 'package:chanthaburi_app/pages/business/menu/restaurant/edit_food.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CardFood extends StatefulWidget {
  String foodName, foodId;
  double price;
  String imageRef;
  String restaurantId;
  String categoryId;
  String description;
  int status;
  List<String> optionId;
  CardFood({
    Key? key,
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.imageRef,
    required this.restaurantId,
    required this.categoryId,
    required this.description,
    required this.status,
    required this.optionId,
  }) : super(key: key);

  @override
  State<CardFood> createState() => _CardFoodState();
}

class _CardFoodState extends State<CardFood> {
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
                  builder: (builder) => EditFood(
                    foodId: widget.foodId,
                    foodName: widget.foodName,
                    price: widget.price,
                    imageRef: widget.imageRef,
                    restaurantId: widget.restaurantId,
                    categoryId: widget.categoryId,
                    description: widget.description,
                    status: widget.status,
                    optionId: widget.optionId,
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
                              widget.foodName,
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
                        FoodCollection.changeStatusFood(widget.foodId, index);
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
