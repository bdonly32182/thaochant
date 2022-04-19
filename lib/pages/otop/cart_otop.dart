import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/otop/confirm_order_product.dart';
import 'package:chanthaburi_app/pages/otop/otop_detail.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_otop.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';

class CartOtop extends StatefulWidget {
  CartOtop({Key? key}) : super(key: key);

  @override
  State<CartOtop> createState() => _CartOtopState();
}

class _CartOtopState extends State<CartOtop> {
  String userId = AuthMethods.currentUser();
  onDeleteFood(String productId) async {
    await SQLiteOtop().deleteProduct(productId, userId);
  }

  _navigateOtop(String otopId) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => OtopDetail(
          otopId: otopId,
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
              future: SQLiteOtop().productByUserId(userId),
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
                  itemBuilder: (BuildContext restaurantContext, int indexRes) {
                    return FutureBuilder(
                        future: SQLiteOtop().productByRestaurant(
                            snapshot.data![indexRes].businessId, userId),
                        builder: (context,
                            AsyncSnapshot<List<ProductCartModel>>
                                foodSnapshot) {
                          if (foodSnapshot.hasError) {
                            return const Text('เกิดเหตุขัดข้อง');
                          }
                          if (foodSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const PouringHourGlass();
                          }
                          return Card(
                            child: Column(
                              children: [
                                buildHeaderCard(
                                  snapshot.data![indexRes].businessName,
                                  snapshot.data![indexRes].businessId,
                                ),
                                listviewProduct(
                                    width, height, foodSnapshot.data!),
                                buildButtonToConfirm(
                                    foodSnapshot.data!,
                                    snapshot.data![indexRes].businessName,
                                    snapshot.data![indexRes].businessId)
                              ],
                            ),
                          );
                        });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildButtonToConfirm(
      List<ProductCartModel> products, String otopName, String otopId) {
    num sumTotalPrice = 0;
    for (ProductCartModel food in products) {
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
            child: const Text('สั่งสินค้า'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => ConfirmOrderProduct(
                    products: products,
                    businessName: otopName,
                    businessId: otopId,
                  ),
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

  ListView listviewProduct(
      double width, double height, List<ProductCartModel> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int indexFood) {
        return FutureBuilder(
            future: ProductOtopCollection.checkProductInCart(
              products[indexFood].productName,
              products[indexFood].businessId,
            ),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("เกิดเหตุขัดข้อง"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PouringHourGlass();
              }
              if (snapshot.data == 0) {
                SQLiteOtop()
                    .deleteProduct(products[indexFood].productId, userId);
                return const Center(
                  child: Text("ไม่พบสินค้ารายการนี้ กรุณาโหลดใหม่"),
                );
              }
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
                        pathImage: products[indexFood].imageURL,
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
                              products[indexFood].productName,
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
                                '${products[indexFood].amount} x ${products[indexFood].price}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                            ),
                            child: Text(
                              '${products[indexFood].totalPrice} ฿',
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
                            onDeleteFood(products[indexFood].productId);
                            setState(() {
                              products.removeAt(indexFood);
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
            });
      },
    );
  }

  InkWell buildHeaderCard(String otopName, otopId) {
    return InkWell(
      onTap: () => _navigateOtop(otopId),
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
            otopName,
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
