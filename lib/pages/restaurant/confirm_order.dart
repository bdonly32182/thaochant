import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/restaurant/checkout.dart';
import 'package:chanthaburi_app/pages/shipping_address/address_info.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_address.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatefulWidget {
  List<ProductCartModel> products;
  String businessName;
  String businessId;
  ConfirmOrder({
    Key? key,
    required this.products,
    required this.businessName,
    required this.businessId,
  }) : super(key: key);

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  String userId = AuthMethods.currentUser();
  num totalPriceProduct = 0;
  num priceShipping = 0;
  @override
  void initState() {
    super.initState();
    fetchAddress();
    setTotalPrice();
  }

  setTotalPrice() {
    num sumTotalPrice = 0;
    for (ProductCartModel product in widget.products) {
      sumTotalPrice += product.totalPrice;
    }
    setState(() {
      totalPriceProduct = sumTotalPrice;
    });
  }

  fetchAddress() async {
    List<ShippingModel> addressList = await SQLAdress().myAddress(userId);
    if (addressList.isNotEmpty) {
      var addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.createAddress(addressList[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyConstant.backgroudApp,
        appBar: AppBar(
          backgroundColor: MyConstant.themeApp,
          title: const Text('ยืนยันคำสั่งซื้อ'),
        ),
        body: Consumer<AddressProvider>(
          builder:
              (BuildContext context, AddressProvider provider, Widget? child) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      AddressInfo(address: provider.address, userId: userId),
                      buildCardOrder(
                          width, height, widget.products, totalPriceProduct),
                      buildCardTotalPrice(
                        widget.products.length,
                        totalPriceProduct,
                        priceShipping,
                      )
                    ],
                  ),
                ),
                buildTabBottom(
                  width,
                  height,
                  totalPriceProduct,
                  provider.address,
                  widget.products,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Card buildCardTotalPrice(
      int totalAmount, num totalPriceProduct, priceShipping) {
    num totalPriceAndShipping = totalPriceProduct + priceShipping;
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ยอดรวม ($totalAmount รายการ)'),
                Text('$totalPriceProduct ฿'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('จ่ายล่วงหน้า  '),
                Text('50 %'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('สรุปราคาที่ต้องชำระ '),
                Text(
                  '${totalPriceAndShipping / 2} ฿',
                  style: TextStyle(
                    fontSize: 18,
                    color: MyConstant.themeApp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card buildCardOrder(double width, height, List<ProductCartModel> products,
      num totalPriceProduct) {
    return Card(
      child: Column(
        children: [
          buildHeaderCard(),
          listviewProducts(width, height, products),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('คำสั่งซื้อทั้งหมด (${products.length} รายการ)'),
                Text(
                  totalPriceProduct.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: MyConstant.themeApp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView listviewProducts(
      double width, height, List<ProductCartModel> products) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int indexProduct) {
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
                    pathImage: products[indexProduct].imageURL,
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  child: Column(
                    children: [
                      Text(
                        products[indexProduct].productName,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                          '${products[indexProduct].amount} x ${products[indexProduct].price} ฿')
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text('${products[indexProduct].totalPrice} ฿'),
                )
              ],
            ),
          );
        });
  }

  Row buildHeaderCard() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.store_outlined,
            color: Colors.grey[700],
          ),
        ),
        Text(
          widget.businessName,
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
    );
  }

  Container buildTabBottom(double width, double height, num totalPriceProduct,
      List<ShippingModel> address, List<ProductCartModel> foods) {
    return Container(
      width: width * 1,
      height: height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ยอดชำระทั้งหมด',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (totalPriceProduct / 2).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: Text(
              'สั่งซื้อ',
              style: TextStyle(
                color: MyConstant.themeApp,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              if (address.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => CheckoutOrder(
                      address: address[0],
                      businessId: widget.businessId,
                      totalPrice: totalPriceProduct,
                      foods: foods,
                      prepaidPrice: totalPriceProduct / 2,
                    ),
                  ),
                );
              } else {
                dialogAlert(context, "แจ้งเตือน", "กรุณาสร้างข้อมูลการติดต่อ");
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: MyConstant.themeApp,
      ),
    );
  }
}
