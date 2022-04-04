import 'package:badges/badges.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/otop/cart_otop.dart';
import 'package:chanthaburi_app/pages/otop/otop_detail.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_otop.dart';
import 'package:chanthaburi_app/utils/sqlite/sqlite_helper.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/search.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ShoppingOtop extends StatefulWidget {
  ShoppingOtop({Key? key}) : super(key: key);

  @override
  State<ShoppingOtop> createState() => _ShoppingOtopState();
}

class _ShoppingOtopState extends State<ShoppingOtop> {
  TextEditingController searchController = TextEditingController();
  final PagingController<int, QueryDocumentSnapshot<Object?>>
      _pagingController = PagingController(firstPageKey: 0);
  QueryDocumentSnapshot? lastDocument;
  List<ProductCartModel> productByOtop = [];
  final int _pageSize = 20;
  bool isSearch = false;
  int? itemCart;
  void onSearch(bool isStatusShow) {
    setState(() {
      isSearch = isStatusShow;
    });
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) => loadMoreRestaurant(pageKey),
    );
    super.initState();
    getTotalRestaurant();
  }

  Future<void> getTotalRestaurant() async {
    List<ProductCartModel> _otops =
        await SQLiteOtop().productByUserId(AuthMethods.currentUser());
    setState(() {
      itemCart = _otops.length;
      productByOtop = _otops;
    });
  }

  Future<void> loadMoreRestaurant(int pageKey) async {
    try {
      QuerySnapshot _resultRestaurant =
          await OtopCollection.otops(lastDocument);
      final isLastPage = _resultRestaurant.docs.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_resultRestaurant.docs);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(_resultRestaurant.docs, nextPageKey);
        lastDocument = _resultRestaurant.docs.last;
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  onRefresh() {
    setState(() {
      lastDocument = null;
    });
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
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
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const InternalError();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<QueryDocumentSnapshot> restaurants =
                        snapshot.data!.docs;
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
                child: PagedListView<int, QueryDocumentSnapshot>(
                  pagingController: _pagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<QueryDocumentSnapshot>(
                    itemBuilder: (context, otops, index) {
                      return Column(
                        children: [
                          Container(
                            child: index == 0
                                ? buildTitle('ร้านผลิตภัณฑ์ทั้งหมด')
                                : null,
                          ),
                          buildCardOtopAll(
                            height,
                            width,
                            otops.id,
                            otops.get("businessName"),
                            otops.get("imageRef"),
                            otops.get("point"),
                            otops.get("ratingCount"),
                            otops.get("statusOpen"),
                            otops.get("address"),
                            otops.get("phoneNumber"),
                            otops.get("latitude"),
                            otops.get("longitude"),
                          ),
                        ],
                      );
                    },
                    firstPageErrorIndicatorBuilder: (_) =>
                        const BadRequestError(),
                    noItemsFoundIndicatorBuilder: (ctx) =>
                        const ShowDataEmpty(),
                    firstPageProgressIndicatorBuilder: (context) =>
                        const PouringHourGlass(),
                    noMoreItemsIndicatorBuilder: (context) => const Center(
                      child: Text("ไม่มีข้อมูล"),
                    ),
                    newPageErrorIndicatorBuilder: (context) =>
                        const BadRequestError(),
                    newPageProgressIndicatorBuilder: (context) =>
                        CircularProgressIndicator(
                      color: MyConstant.colorStore,
                    ),
                  ),
                ),
              ));
  }

  ListView buildListViewOtopAll(
      double height, double width, List<QueryDocumentSnapshot> otops) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
      lng) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          if (statusOpen == 0) {
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
                        children: statusOpen == 0
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
                        color: statusOpen == 0
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
