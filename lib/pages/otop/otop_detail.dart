import 'dart:developer';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/models/history/history.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/detail_business/detail_business.dart';
import 'package:chanthaburi_app/pages/otop/category_otop.dart';
import 'package:chanthaburi_app/pages/otop/confirm_order_product.dart';
import 'package:chanthaburi_app/provider/product_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/history_collection.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_otop.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OtopDetail extends StatefulWidget {
  final String otopId;
  const OtopDetail({Key? key, required this.otopId}) : super(key: key);

  @override
  State<OtopDetail> createState() => _OtopDetailState();
}

class _OtopDetailState extends State<OtopDetail> with WidgetsBindingObserver {
  HistoryBusinessModel historyBusinessModel = HistoryBusinessModel(
    userId: AuthMethods.currentUser(),
    businessId: '',
    timeIn: DateTime.now(),
    timeOut: DateTime.now(),
    totalTime: 0,
    typeBusiness: MyConstant.typeRestaurant,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    fetchsProduct();
  }

  fetchsProduct() async {
    List<ProductCartModel> foods = await SQLiteOtop()
        .productByRestaurant(widget.otopId, AuthMethods.currentUser());
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchsProduct(foods);
  }

  setHistory(String businessId, DateTime dateTimeOut) async {
    try {
      // แสดงว่า เคยเพิ่มไปแล้ว เพราะ didChangeAppLifecycleState มันทำหลายรอบ เลยต้องดักไว้
      if (historyBusinessModel.businessId.isEmpty) {
        int totalTime =
            dateTimeOut.difference(historyBusinessModel.timeIn).inSeconds;
        historyBusinessModel.businessId = businessId;
        historyBusinessModel.totalTime = totalTime;
        await HistoryCollection().saveHistoryOtop(historyBusinessModel);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      setHistory(widget.otopId, DateTime.now());
    }
  }

  @override
  void dispose() {
    super.dispose();
    setHistory(widget.otopId, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyConstant.backgroudApp,
        body: Consumer<ProductProvider>(
            builder: (context, ProductProvider provider, snapshot) {
          return FutureBuilder(
              future: OtopCollection.otopById(widget.otopId),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<BusinessModel>> snapshotOtop) {
                if (snapshotOtop.hasError) {
                  return const InternalError();
                }
                if (snapshotOtop.connectionState == ConnectionState.waiting) {
                  return const PouringHourGlass();
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          buildImageOtop(width, height,
                              snapshotOtop.data!.get('imageRef')),
                          buildDetail(
                            width,
                            height,
                            snapshotOtop.data!.get('businessName'),
                            snapshotOtop.data!.get('address'),
                            snapshotOtop.data!.get('phoneNumber'),
                            snapshotOtop.data!.get('latitude'),
                            snapshotOtop.data!.get('longitude'),
                            snapshotOtop.data!.get('point'),
                            snapshotOtop.data!.get('ratingCount'),
                            snapshotOtop.data!.get('policyDescription'),
                            snapshotOtop.data!.get('policyName'),
                            snapshotOtop.data!.get("imageRef"),
                          ),
                          CategoryOtop(
                            businessId: widget.otopId,
                            otopName: snapshotOtop.data!.get('businessName'),
                            products: provider.products,
                            status: snapshotOtop.data!.get("statusOpen"),
                            times: snapshotOtop.data!.data()!.times,
                          )
                        ],
                      ),
                    ),
                    buildButtonCheckout(
                      height,
                      width,
                      provider.products,
                      snapshotOtop.data!.get('businessName'),
                      snapshotOtop.data!.get("statusOpen"),
                      snapshotOtop.data!.data()!.times,
                    ),
                  ],
                );
              });
        }),
      ),
    );
  }

  Container buildButtonCheckout(
    double height,
    double width,
    List<ProductCartModel> foods,
    String restaurantName,
    int status,
    List<TimeTurnOnOfModel> times,
  ) {
    num totalAmountAll = 0;
    num totalPriceAll = 0;
    for (ProductCartModel food in foods) {
      totalPriceAll += food.totalPrice;
      totalAmountAll += food.amount;
    }
    bool? isClose;
    DateTime dateNow = DateTime.now();
    String currentDay = DateFormat('EEEE').format(dateNow);
    String? dayThai = MyConstant.dayThailand[currentDay];
    List<TimeTurnOnOfModel> timeCurrent = times
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
      isClose = status == 0;
    }
    return Container(
      width: double.maxFinite,
      height: height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.85,
            height: 50,
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    totalAmountAll.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    'สั่งสินค้า',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$totalPriceAll ฿',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              onPressed: isClose || foods.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ConfirmOrderProduct(
                            products: foods,
                            businessName: restaurantName,
                            businessId: widget.otopId,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
            ),
          ),
        ],
      ),
      decoration: const BoxDecoration(color: Colors.white),
    );
  }

  Card buildDetail(
      double width,
      double height,
      String businessName,
      address,
      phoneNumber,
      double lat,
      lng,
      num point,
      ratingCount,
      List<dynamic> policyDescription,
      List<dynamic> policyName,
      String imageRef) {
    return Card(
      child: SizedBox(
        width: width * 1,
        child: Column(
          children: [
            buildNameOtop(width, businessName, address, phoneNumber, lat, lng,
                point, ratingCount, policyDescription, policyName, imageRef),
            buildDescription(width, address, point, ratingCount),
          ],
        ),
      ),
    );
  }

  Stack buildImageOtop(double width, double height, String imageRef) {
    return Stack(
      children: [
        Container(
          width: width * 1,
          height: height * 0.25,
          child: ShowImageNetwork(
            colorImageBlank: MyConstant.themeApp,
            pathImage: imageRef,
          ),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white54,
                blurRadius: 5,
                offset: Offset(0, 6),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Column buildDescription(
      double width, String address, num point, ratingCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          width: width * 1,
          child: Text(
            address,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, bottom: 8.0),
          child: Row(
            children: [
              RatingBar.builder(
                itemSize: 20.0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                initialRating: point / ratingCount,
                itemCount: point != 0.0 && ratingCount != 0.0
                    ? (point / ratingCount).floor()
                    : 1,
                ignoreGestures: true,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (ratingUpdate) {},
              ),
              Text(
                (point != 0.0 && ratingCount != 0.0
                        ? (point / ratingCount).floor()
                        : 0)
                    .toString(),
              ),
              Text('($ratingCount)'),
            ],
          ),
        )
      ],
    );
  }

  Row buildNameOtop(
      double width,
      String businessName,
      address,
      phoneNumber,
      double lat,
      lng,
      num point,
      ratingCount,
      List<dynamic> policyDescription,
      List<dynamic> policyName,
      String imageRef) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, left: 20),
          width: width * 0.6,
          child: Text(
            businessName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ),
        SizedBox(
          width: width * 0.3,
          child: TextButton(
            child: Text(
              'ดูข้อมูลร้าน >',
              style: TextStyle(
                color: MyConstant.themeApp,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => DetailBusiness(
                    businessId: widget.otopId,
                    businessName: businessName,
                    address: address,
                    lat: lat,
                    lng: lng,
                    phoneNumber: phoneNumber,
                    point: point,
                    ratingCount: ratingCount,
                    policyDescription: policyDescription,
                    policyName: policyName,
                    imageRef: imageRef,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
