import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/pages/package_toure/checkout_tour.dart';
import 'package:chanthaburi_app/pages/shipping_address/create_shipping_address.dart';
import 'package:chanthaburi_app/pages/shipping_address/shipping_adress.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_address.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingTour extends StatefulWidget {
  String imageRef, packageName, tourId;
  double priceAdult, priceSenior, priceYouth;
  BookingTour(
      {Key? key,
      required this.imageRef,
      required this.tourId,
      required this.packageName,
      required this.priceAdult,
      required this.priceSenior,
      required this.priceYouth})
      : super(key: key);

  @override
  State<BookingTour> createState() => _BookingTourState();
}

class _BookingTourState extends State<BookingTour> {
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now();
  double totalPrice = 0;
  int totalAdult = 0;
  int totalSenior = 0;
  int totalYouth = 0;
  String userId = AuthMethods.currentUser();
  fetchAddress() async {
    List<ShippingModel> addressList = await SQLAdress().myAddress(userId);
    if (addressList.isNotEmpty) {
      var addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.createAddress(addressList[0]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAddress();
  }

  _increaseMember(double price, String type) {
    setState(() {
      if (type == 'adult') {
        totalAdult += 1;
      }
      if (type == 'senior') {
        totalSenior += 1;
      }
      if (type == 'youth') {
        totalYouth += 1;
      }
      totalPrice += price;
    });
  }

  _decreaseMember(double price, String type) {
    setState(() {
      if (type == 'adult') {
        totalAdult -= 1;
      }
      if (type == 'senior') {
        totalSenior -= 1;
      }
      if (type == 'youth') {
        totalYouth -= 1;
      }
      totalPrice -= price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyConstant.backgroudApp,
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildImagePackage(width, height, widget.imageRef),
              buildColumnInImage(widget.packageName),
              buildStartAndEndDate(width),
              buildSelect(height, width),
              Consumer<AddressProvider>(
                builder: (BuildContext context, AddressProvider addressProvider,
                    Widget? child) {
                  return Column(
                    children: [
                      buildAddressInfo(width, height, addressProvider.address),
                      buildTabCheckout(
                          height, widget.packageName, addressProvider.address),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
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

  Container buildSelect(double height, double width) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.04),
      height: height * 0.338,
      width: width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'เลือกจำนวนผู้เข้าร่วม',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          buildAdult(width, widget.priceAdult),
          buildSenior(width, widget.priceSenior),
          buildYouth(width, widget.priceYouth),
        ],
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    );
  }

  Row buildYouth(double width, double priceYouth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'เด็ก (ราคา $priceYouth)      ',
          style: TextStyle(
            fontSize: 16,
            color: MyConstant.themeApp,
          ),
        ),
        SizedBox(
          width: width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: totalYouth <= 0
                    ? null
                    : () {
                        _decreaseMember(priceYouth, 'youth');
                      },
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: totalYouth < 1 ? Colors.grey[400] : Colors.grey[700],
                ),
                iconSize: 40,
                disabledColor: Colors.grey[400],
              ),
              Text(
                totalYouth.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () => totalAdult == 0 && totalSenior == 0
                    ? null
                    : _increaseMember(priceYouth, 'youth'),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey[700],
                ),
                iconSize: 40,
              ),
            ],
          ),
        )
      ],
    );
  }

  Row buildSenior(double width, double priceSenior) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'ผู้สูงอายุ (ราคา $priceSenior)',
          style: TextStyle(
            fontSize: 16,
            color: MyConstant.themeApp,
          ),
        ),
        SizedBox(
          width: width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: totalSenior <= 0
                    ? null
                    : () {
                        _decreaseMember(priceSenior, 'senior');
                      },
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: totalSenior < 1 ? Colors.grey[400] : Colors.grey[700],
                ),
                iconSize: 40,
                disabledColor: Colors.grey[400],
              ),
              Text(
                totalSenior.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () {
                  _increaseMember(priceSenior, 'senior');
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey[700],
                ),
                iconSize: 40,
              ),
            ],
          ),
        )
      ],
    );
  }

  Row buildAdult(double width, double priceAdult) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'ผู้ใหญ่ (ราคา $priceAdult)',
          style: TextStyle(
            fontSize: 16,
            color: MyConstant.themeApp,
          ),
        ),
        SizedBox(
          width: width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: totalAdult <= 0
                    ? null
                    : () {
                        _decreaseMember(priceAdult, 'adult');
                      },
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: totalAdult < 1 ? Colors.grey[400] : Colors.grey[700],
                ),
                iconSize: 40,
                disabledColor: Colors.grey[400],
              ),
              Text(
                totalAdult.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () {
                  _increaseMember(priceAdult, 'adult');
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey[700],
                ),
                iconSize: 40,
              ),
            ],
          ),
        )
      ],
    );
  }

  Container buildTabCheckout(
    double height,
    String tourName,
    List<ShippingModel> address,
  ) {
    return Container(
      width: double.maxFinite,
      height: height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ยอดรวมทั้งหมด',
                style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 16,
                ),
              ),
              Text(
                totalPrice.toString(),
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
              'ชำระเงิน',
              style: TextStyle(fontSize: 16, color: MyConstant.themeApp),
            ),
            onPressed: () {
              if (totalPrice != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => CheckoutTour(
                      totalPrice: totalPrice,
                      tourId: widget.tourId,
                      tourName: tourName,
                      adult: totalAdult,
                      checkIn: checkIn,
                      checkOut: checkOut,
                      senior: totalSenior,
                      youth: totalYouth,
                      address: address[0],
                    ),
                  ),
                );
              } else {
                dialogAlert(context, "แจ้งเตือน",
                    "กรุณาเลือกผู้เข้าร่วมอย่างน้อย 1 คน");
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: MyConstant.themeApp),
    );
  }

  Container buildImagePackage(double width, double height, String imageRef) {
    return Container(
      width: width * 1,
      height: height * 0.3,
      child: Stack(
        children: [
          ShowImageNetwork(
              pathImage: imageRef, colorImageBlank: MyConstant.themeApp),
          buildArrowBack(),
        ],
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  Row buildArrowBack() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 10),
            child: const Center(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Column buildColumnInImage(String packageName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 5.0),
          child: Row(
            children: [
              Text(
                packageName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildStartAndEndDate(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10),
              width: width * 0.3,
              child: DateTimePicker(
                dateHintText: 'วันที่ไปเที่ยว',
                firstDate: DateTime(2022),
                lastDate: DateTime(2100),
                onChanged: (val) {
                  setState(() {
                    checkIn = DateTime.parse(val);
                  });
                },
                style: TextStyle(
                  color: MyConstant.themeApp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        const Icon(Icons.arrow_forward),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: width * 0.3,
              child: DateTimePicker(
                dateHintText: 'วันที่จะกลับ',
                firstDate: DateTime(2022),
                lastDate: DateTime(2100),
                onChanged: (val) {
                  setState(() {
                    checkOut = DateTime.parse(val);
                  });
                },
                style: TextStyle(
                  color: MyConstant.themeApp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.date_range),
            ),
            Text('${checkOut.difference(checkIn).inDays} วัน'),
          ],
        )
      ],
    );
  }
}
