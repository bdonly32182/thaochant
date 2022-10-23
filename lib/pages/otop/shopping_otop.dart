import 'package:badges/badges.dart';
import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/models/otop/product.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/otop/cart_otop.dart';
import 'package:chanthaburi_app/pages/otop/otop_detail.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_otop.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/search.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ShoppingOtop extends StatefulWidget {
  ShoppingOtop({Key? key}) : super(key: key);

  @override
  State<ShoppingOtop> createState() => _ShoppingOtopState();
}

class _ShoppingOtopState extends State<ShoppingOtop> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot<BusinessModel>> randomOtops = [];
  List<QueryDocumentSnapshot<ProductOtopModel>> randomProducts = [];
  List<ProductCartModel> productByOtop = [];
  bool isSearch = false;
  bool isLoading = true;
  int? itemCart;
  void onSearch(bool isStatusShow) {
    setState(() {
      isSearch = isStatusShow;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRandomProducts();
    onFetchsOtop();
    getTotalRestaurant();
  }

  fetchRandomProducts() async {
    DateTime endDateTime = DateTime.now();
    DateTime startDateTime = DateTime(endDateTime.year, endDateTime.month - 1);
    List<QueryDocumentSnapshot<ProductOtopModel>> _randomProduct =
        await ProductOtopCollection.randomProducts(
      startDateTime.millisecondsSinceEpoch,
      endDateTime.millisecondsSinceEpoch,
    );
    setState(() {
      randomProducts = _randomProduct;
    });
  }

  Future<void> getTotalRestaurant() async {
    List<ProductCartModel> _otops =
        await SQLiteOtop().productByUserId(AuthMethods.currentUser());
    setState(() {
      itemCart = _otops.length;
      productByOtop = _otops;
    });
  }

  onFetchsOtop() async {
    List<QueryDocumentSnapshot<BusinessModel>> _randomOtops =
        await OtopCollection.otops();
    setState(() {
      randomOtops = _randomOtops;
      isLoading = false;
    });
  }

  onRefresh() {
    fetchRandomProducts();
    onFetchsOtop();
    getTotalRestaurant();
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
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: MyConstant.themeApp,
        title: Form(
          child: Search(
            searchController: searchController,
            onSearch: onSearch,
            labelText: 'ค้นหาร้านผลิตภัณฑ์ :',
            colorIcon: MyConstant.colorStore,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Badge(
              position: BadgePosition.topStart(),
              badgeContent: Text(itemCart.toString()),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => CartOtop(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: isSearch
          ? FutureBuilder(
              future: OtopCollection.searchOtop(searchController.text),
              builder: (context,
                  AsyncSnapshot<List<QueryDocumentSnapshot<BusinessModel>>>
                      snapshot) {
                if (snapshot.hasError) {
                  return const InternalError();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List<QueryDocumentSnapshot<BusinessModel>> restaurants =
                      snapshot.data!;
                  if (restaurants.isEmpty) {
                    return const Center(child: ShowDataEmpty());
                  }
                  return ListView(
                    children: [
                      Column(
                        children: [
                          buildTitle('ผลลัพทธ์การค้นหา'),
                        ],
                      ),
                      buildListViewOtopAll(height, width, restaurants),
                    ],
                  );
                }
                return const PouringHourGlass();
              })
          : RefreshIndicator(
              onRefresh: () => Future.sync(() => onRefresh()),
              child: isLoading
                  ? const PouringHourGlass()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          buildTitle("แนะนำสินค้าโอทอป"),
                          buildRecomended(height, width),
                          buildTitle("ร้านโอทอปทั้งหมด"),
                          buildListViewOtopAll(
                            height,
                            width,
                            randomOtops,
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }

  SizedBox buildRecomended(double height, double width) {
    return SizedBox(
      height: height * 0.22,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: randomProducts.length,
        itemBuilder: (itemBuilder, index) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtopDetail(otopId: randomProducts[index].data().otopId),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(6.0),
              width: width * 0.34,
              height: height * 0.2,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.15,
                    child: ShowImageNetwork(
                      pathImage: randomProducts[index].data().imageRef,
                      colorImageBlank: MyConstant.colorStore,
                    ),
                  ),
                  Text(
                    randomProducts[index].data().productName,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  ListView buildListViewOtopAll(double height, double width,
      List<QueryDocumentSnapshot<BusinessModel>> otops) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: otops.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCardOtopAll(
          height,
          width,
          otops[index].id,
          otops[index]["businessName"],
          otops[index]["imageRef"],
          otops[index]["point"],
          otops[index]["ratingCount"],
          otops[index]["statusOpen"],
          otops[index]["address"],
          otops[index]["phoneNumber"],
          otops[index]["latitude"],
          otops[index]["longitude"],
          otops[index].data().times,
        );
      },
    );
  }

  Card buildCardOtopAll(
      double height,
      double width,
      String otopId,
      String restaurantName,
      String imageRef,
      num point,
      num ratingCount,
      int statusOpen,
      String address,
      String phoneNumber,
      double lat,
      lng,List<TimeTurnOnOfModel> times,) {
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
      isClose = statusOpen == 0;
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          if (isClose!) {
            dialogAlert(context, "แจ้งเตือน", "ไม่เปิดทำการ ณ ขณะนี้");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtopDetail(otopId: otopId),
              ),
            );
          }
        },
        child: SizedBox(
          height: height * .22,
          width: width * 1,
          child: Column(
            children: [
              SizedBox(
                width: width * 7,
                height: height * 0.16,
                child: Stack(
                  children: [
                    ShowImageNetwork(
                      colorImageBlank: MyConstant.themeApp,
                      pathImage: imageRef,
                    ),
                    Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: isClose
                            ? const [
                                Text(
                                  "ร้านปิดอยู่",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ]
                            : [],
                      ),
                      decoration: BoxDecoration(
                        color: isClose
                            ? Colors.black54
                            : Colors.transparent,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurantName,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          initialRating: 1,
                          itemCount: 1,
                          ignoreGestures: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (ratingUpdate) {
                            print(ratingUpdate);
                          },
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
