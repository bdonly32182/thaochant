import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/payment/confirm_order.dart';
import 'package:chanthaburi_app/pages/restaurant/restaurant_detail.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/cart_restaurant.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';

class CartRestaurant extends StatefulWidget {
  CartRestaurant({Key? key}) : super(key: key);

  @override
  State<CartRestaurant> createState() => _CartRestaurantState();
}

class _CartRestaurantState extends State<CartRestaurant> {
  String userId = AuthMethods.currentUser();
  onDeleteFood(String foodId) async {
    await SQLiteRestaurant().deleteFood(foodId, AuthMethods.currentUser());
  }

  _navigateRestaurant(String restaurantId) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => RestaurantDetail(
          restaurantId: restaurantId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    SQLiteHelper().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('ตะกร้าของฉัน'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder(
                future:
                    SQLiteRestaurant().foodByUserId(userId),
                builder:
                    (context, AsyncSnapshot<List<ProductCartModel>> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('เกิดเหตุขัดข้อง');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder:
                        (BuildContext restaurantContext, int indexRes) {
                      return FutureBuilder(
                          future: SQLiteRestaurant().foodsByRestaurant(
                              snapshot.data![indexRes].businessId, userId),
                          builder: (context,
                              AsyncSnapshot<List<ProductCartModel>>
                                  foodSnapshot) {
                            if (foodSnapshot.hasError) {
                              return const Text('เกิดเหตุขัดข้อง');
                            }
                            if (foodSnapshot.connectionState == ConnectionState.waiting) {
                              return const PouringHourGlass();
                            }
                            return Card(
                              child: Column(
                                children: [
                                  buildHeaderCard(
                                    snapshot.data![indexRes].businessName,
                                    snapshot.data![indexRes].businessId,
                                  ),
                                  listviewFood(
                                      width, height, foodSnapshot.data!),
                                  buildButtonToConfirm(foodSnapshot.data!)
                                ],
                              ),
                            );
                          });
                    },
                  );
                },),
          ],
        ),
      ),
    );
  }

  Padding buildButtonToConfirm(List<ProductCartModel> foods) {
    num sumTotalPrice = 0;
    for (ProductCartModel food in foods) {
      sumTotalPrice += food.totalPrice;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ทั้งหมด: $sumTotalPrice ฿',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MyConstant.themeApp,
            ),
          ),
          ElevatedButton(
            child: const Text('สั่งอาหาร'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => ConfirmOrder(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: MyConstant.themeApp,
            ),
          ),
        ],
      ),
    );
  }

  ListView listviewFood(
      double width, double height, List<ProductCartModel> foods) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (BuildContext context, int indexFood) {
        return Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  colorImageBlank: MyConstant.themeApp,
                  pathImage: foods[indexFood].imageURL,
                ),
              ),
              SizedBox(
                width: width * 0.46,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                        left: 10,
                      ),
                      child: Text(
                        foods[indexFood].productName,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        bottom: 5,
                      ),
                      child: Text(
                          '${foods[indexFood].amount} x ${foods[indexFood].price}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                      ),
                      child: Text(
                        '${foods[indexFood].totalPrice} ฿',
                        style: TextStyle(
                          color: MyConstant.themeApp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.16,
                child: IconButton(
                    onPressed: () {
                      onDeleteFood(foods[indexFood].productId);
                      setState(() {
                        foods.removeAt(indexFood);
                      });
                    },
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  InkWell buildHeaderCard(String restaurantName, restaurantId) {
    return InkWell(
      onTap: () => _navigateRestaurant(restaurantId),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.store_outlined,
              color: Colors.grey[700],
            ),
          ),
          Text(
            restaurantName,
            style: TextStyle(fontSize: 16, color: MyConstant.themeApp),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '>',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
