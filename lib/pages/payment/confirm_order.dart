import 'package:chanthaburi_app/pages/payment/checkout.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';
class ConfirmOrder extends StatefulWidget {
  ConfirmOrder({Key? key}) : super(key: key);

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
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
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildAddressInfo(width, height),
                  buildCardOrder(width),
                  buildCardTotalPrice()
                ],
              ),
            ),
            buildTabBottom(width, height)
          ],
        ),
      ),
    );
  }

  Card buildCardTotalPrice() {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ยอดรวม (3 รายการ)'),
                Text('300 ฿'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ค่าจัดส่ง '),
                Text('30 ฿'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('รวมทั้งสิ้น '),
                Text(
                  '330 ฿',
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

  Card buildCardOrder(double width) {
    return Card(
      child: Column(
        children: [
          buildHeaderCard(),
          ListviewFood(width),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('คำสั่งซื้อทั้งหมด (3 รายการ)'),
                Text(
                  '300 ฿',
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

  ListView ListviewFood(double width) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (BuildContext context, int indexFood) {
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: width * 0.25,
                  child: ShowImage(
                    pathImage: MyConstant.shopImage,
                  ),
                ),
                Container(
                  width: width * 0.4,
                  child: Column(
                    children: [
                      Text(
                        'food name',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('1 x 100 ฿')
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('100 ฿'),
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
          'ชื่อร้านอาหาร',
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

  Card buildAddressInfo(double width, double height) {
    return Card(
      child: InkWell(
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (builder) => ShippingAddress(),
        //     ),
        //   );
        // },
        child: Column(
          children: [
            Container(
              width: width * 0.9,
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  Text('ที่อยู่จัดส่ง'),
                ],
              ),
            ),
            Container(
              width: width * 0.7,
              margin: EdgeInsets.only(
                top: 10.0,
              ),
              child: Row(
                children: [
                  Text('นาย จักรพันธ์ เพียเพ็งต้น'),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text('|'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text('0814206492'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: width * 0.7,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '19/19 แสมดำ บางขุนเทียน กรงเทพมหานคร 10150',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildTabBottom(double width, double height) {
    return Container(
      width: width * 1,
      height: height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ยอดชำระทั้งหมด',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '330 ฿',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            child: ElevatedButton(
              child: Text(
                'สั่งซื้อ',
                style: TextStyle(
                  color: MyConstant.themeApp,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                print(
                    'remove menu in cart and create order and go to checkout');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => CheckoutOrder(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: MyConstant.themeApp,
      ),
    );
  }
}