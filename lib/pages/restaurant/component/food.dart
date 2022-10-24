import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/restaurant/add_to_cart.dart';
import 'package:chanthaburi_app/provider/product_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_login.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Food extends StatefulWidget {

  final String businessId, categoryId, categoryName, restaurantName;
  final List<ProductCartModel> foods;
  final int status;
  final List<TimeTurnOnOfModel> times;
  const Food({
    Key? key,
    required this.businessId,
    required this.categoryId,
    required this.categoryName,
    required this.restaurantName,
    required this.foods,
    required this.status,
    required this.times,
  }) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: FoodCollection.foods(widget.businessId, widget.categoryId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('เกิดเหตุขัดข้อง');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text('');
        }
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.categoryName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    bool? isClose;
                    DateTime dateNow = DateTime.now();
                    String currentDay = DateFormat('EEEE').format(dateNow);
                    String? dayThai = MyConstant.dayThailand[currentDay];
                    List<TimeTurnOnOfModel> timeCurrent = widget.times
                        .where(
                          (element) => element.day == dayThai,
                        )
                        .toList();
                    if (timeCurrent.isNotEmpty) {
                      List<String> splitTime = timeCurrent[0].timeOf.split(':');
                      DateTime dateTime = DateTime(
                        dateNow.year,
                        dateNow.month,
                        dateNow.day,
                        int.parse(splitTime[0]),
                        int.parse(splitTime[1]),
                      );

                      isClose = dateNow.compareTo(dateTime) == 1;
                    } else {
                      isClose = widget.status == 0;
                    }
                    String userId = AuthMethods.currentUser();
                    if (isClose) {
                      dialogAlert(
                          context, "ประกาศ", "ร้านยังไม่เปิดให้บริการชั่วคราว");
                      return;
                    }
                    if (userId.isEmpty) {
                      dialogLogin(context);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddToCart(
                          foodId: snapshot.data!.docs[index].id,
                          price: snapshot.data!.docs[index]["price"],
                          foodImage: snapshot.data!.docs[index]["imageRef"],
                          foodName: snapshot.data!.docs[index]["foodName"],
                          description: snapshot.data!.docs[index]
                              ["description"],
                          restaurantId: snapshot.data!.docs[index]
                              ["restaurantId"],
                          restaurantName: widget.restaurantName,
                          foods: widget.foods
                              .where(
                                (element) =>
                                    element.productId ==
                                    snapshot.data!.docs[index].id,
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 14.0,
                            bottom: 14.0,
                            left: 10.0,
                          ),
                          width: width * 0.28,
                          height: height * 0.1,
                          child: ShowImageNetwork(
                            pathImage: snapshot.data!.docs[index]["imageRef"],
                            colorImageBlank: MyConstant.themeApp,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.46,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 10),
                                child: Text(
                                  snapshot.data!.docs[index]["foodName"],
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 16.0),
                                child: Text(
                                  '${snapshot.data!.docs[index]["price"]} ฿',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<ProductProvider>(
                          builder: (context, ProductProvider productProvider,
                              child) {
                            List<ProductCartModel> foods = productProvider
                                .products
                                .where((foodItem) =>
                                    foodItem.productId ==
                                    snapshot.data!.docs[index].id)
                                .toList();
                            return Column(
                              children: [
                                Container(
                                  width: width * 0.06,
                                  height: 20,
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 20,
                                  ),
                                  child: foods.isEmpty
                                      ? null
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              foods[0].amount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                  decoration: BoxDecoration(
                                    color: foods.isEmpty
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  width: 22,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        '+',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade700,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
