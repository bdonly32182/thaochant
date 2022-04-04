import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/otop/checkout_product.dart';
import 'package:chanthaburi_app/pages/shipping_address/create_shipping_address.dart';
import 'package:chanthaburi_app/pages/shipping_address/shipping_adress.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/calculate_shipping.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_address.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmOrderProduct extends StatefulWidget {
  List<ProductCartModel> products;
  String businessName;
  String businessId;
  ConfirmOrderProduct({
    Key? key,
    required this.businessId,
    required this.businessName,
    required this.products,
  }) : super(key: key);

  @override
  State<ConfirmOrderProduct> createState() => _ConfirmOrderProductState();
}

class _ConfirmOrderProductState extends State<ConfirmOrderProduct> {
  String userId = AuthMethods.currentUser();
  num totalPriceProduct = 0;
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
                      buildAddressInfo(width, height, provider.address),
                      buildCardOrder(
                          width, height, widget.products, totalPriceProduct),
                      buildCardTotalPrice(
                        widget.products.length,
                        totalPriceProduct,
                        CalculateShipping().calculateShipping(widget.products),
                      )
                    ],
                  ),
                ),
                buildTabBottom(
                  width,
                  height,
                  totalPriceProduct,
                  CalculateShipping().calculateShipping(widget.products),
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
      int totalAmount, num totalPriceProduct, double priceShipping) {
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text('ค่าจุดส่ง  '),
          //       Text("${priceShipping.toStringAsFixed(2)} ฿"),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('สรุปราคาที่ต้องชำระ '),
                Text(
                  '${totalPriceProduct.toStringAsFixed(2)} ฿',
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
                Text('สินค้าทั้งหมด (${products.length} รายการ)'),
                // Text(
                //   totalPriceProduct.toString(),
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: MyConstant.themeApp,
                //   ),
                // ),
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

  Card buildAddressInfo(
      double width, double height, List<ShippingModel> address) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => address.isEmpty
                  ? CreateShippingAddress(
                      isNewAddress: true,
                    )
                  : ShippingAddress(),
            ),
          );
        },
        child: address.isNotEmpty
            ? Column(
                children: [
                  Container(
                    width: width * 0.9,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: const [
                        Icon(Icons.contact_mail_outlined),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('ข้อมูลการติดต่อ'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width * 0.7,
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Row(
                      children: [
                        Text(address[0].fullName),
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text('|'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(address[0].phoneNumber),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: width * 0.7,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            address[0].address,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    Text(
                      'ไม่มีข้อมูลติดต่อ',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      'สร้างข้อมูลติดต่อ',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      'คลิ๊ก',
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Container buildTabBottom(
      double width,
      double height,
      num totalPriceProduct,
      double priceShipping,
      List<ShippingModel> address,
      List<ProductCartModel> products) {
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
                // (totalPriceProduct + priceShipping).toStringAsFixed(2),
                totalPriceProduct.toStringAsFixed(2),
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
                    builder: (builder) => CheckoutProduct(
                      address: address[0],
                      businessId: widget.businessId,
                      totalPrice: totalPriceProduct,
                      products: products,
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
