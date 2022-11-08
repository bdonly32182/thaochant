import 'package:badges/badges.dart';
import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/models/restaurant/food.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/restaurant/cart_restaurant.dart';
import 'package:chanthaburi_app/pages/restaurant/restaurant_detail.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/cart_restaurant.dart';
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

class ShoppingRestaurant extends StatefulWidget {
  const ShoppingRestaurant({Key? key}) : super(key: key);

  @override
  _ShoppingRestaurantState createState() => _ShoppingRestaurantState();
}

class _ShoppingRestaurantState extends State<ShoppingRestaurant> {
  TextEditingController searchController = TextEditingController();
  List<ProductCartModel> foodByRestaurant = [];
  List<QueryDocumentSnapshot<BusinessModel>> randomRestaurants = [];
  List<QueryDocumentSnapshot<FoodModel>> randomFoods = [];
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
    fetchRandomFoods();
    onFetchsResturant();
    getTotalRestaurant();
  }

  fetchRandomFoods() async {
    DateTime endDateTime = DateTime.now();
    DateTime startDateTime = DateTime(endDateTime.year, endDateTime.month - 1);
    List<QueryDocumentSnapshot<FoodModel>> _randomFoods =
        await FoodCollection.randomFood(
      startDateTime.millisecondsSinceEpoch,
      endDateTime.millisecondsSinceEpoch,
    );
    setState(() {
      randomFoods = _randomFoods;
    });
  }

  Future<void> getTotalRestaurant() async {
    List<ProductCartModel> _restaurants =
        await SQLiteRestaurant().foodByUserId(AuthMethods.currentUser());
    setState(() {
      itemCart = _restaurants.length;
      foodByRestaurant = _restaurants;
    });
  }

  onFetchsResturant() async {
    List<QueryDocumentSnapshot<BusinessModel>> _randomRestaurants =
        await RestaurantCollection.restaurants();
    setState(() {
      randomRestaurants = _randomRestaurants;
      isLoading = false;
    });
  }

  onRefresh() {
    fetchRandomFoods();
    onFetchsResturant();
    getTotalRestaurant();
  }

  @override
  void dispose() {
    SQLiteHelper().close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    print(randomFoods);
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
            labelText: 'ค้นหาร้านอาหาร :',
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
                      builder: (builder) => CartRestaurant(),
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
              future:
                  RestaurantCollection.searchRestaurant(searchController.text),
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
                      buildListViewRestaurantAll(height, width, restaurants),
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
                          buildTitle("แนะนำเมนูอาหาร"),
                          buildRecomendedFood(height, width),
                          buildTitle("ร้านอาหารทั้งหมด"),
                          buildListViewRestaurantAll(
                            height,
                            width,
                            randomRestaurants,
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }

  SizedBox buildRecomendedFood(double height, double width) {
    return SizedBox(
      height: height * 0.22,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: randomFoods.length,
        itemBuilder: (itemBuilder, index) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => RestaurantDetail(
                  restaurantId: randomFoods[index].data().restaurantId,
                ),
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
                      pathImage: randomFoods[index].data().imageRef,
                      colorImageBlank: MyConstant.colorStore,
                    ),
                  ),
                  Text(
                    randomFoods[index].data().foodName,
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

  ListView buildListViewRestaurantAll(double height, double width,
      List<QueryDocumentSnapshot<BusinessModel>> restaurants) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCardRestaurantAll(
          height,
          width,
          restaurants[index].id,
          restaurants[index]["businessName"],
          restaurants[index]["imageRef"],
          restaurants[index]["point"],
          restaurants[index]["ratingCount"],
          restaurants[index]["statusOpen"],
          restaurants[index]["address"],
          restaurants[index]["phoneNumber"],
          restaurants[index]["latitude"],
          restaurants[index]["longitude"],
          restaurants[index].data().times,
        );
      },
    );
  }

  Card buildCardRestaurantAll(
    double height,
    double width,
    String restaurantId,
    String restaurantName,
    String imageRef,
    num point,
    num ratingCount,
    int statusOpen,
    String address,
    String phoneNumber,
    double lat,
    lng,
    List<TimeTurnOnOfModel> times,
  ) {
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
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetail(
                restaurantId: restaurantId,
              ),
            ),
          );
        },
        child: SizedBox(
          height: height * .25,
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
                        color: isClose ? Colors.black54 : Colors.transparent,
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
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Icon(
                      Icons.delivery_dining_outlined,
                      color: Colors.grey.shade700,
                    ),
                    Text(
                      'จองเท่านั้น',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )
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
