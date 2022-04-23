import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/order_food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/order_product_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessPopularCard extends StatefulWidget {
  List<QueryDocumentSnapshot<BusinessModel>> business;
  List<String> categories;
  int start;
  int end;
  String type;
  BusinessPopularCard({
    Key? key,
    required this.business,
    required this.categories,
    required this.end,
    required this.start,
    required this.type,
  }) : super(key: key);

  @override
  State<BusinessPopularCard> createState() => _BusinessPopularCardState();
}

class _BusinessPopularCardState extends State<BusinessPopularCard> {
  List<Map<String, dynamic>> sortBusiness = [];
  @override
  void initState() {
    super.initState();
    popularSort(
      widget.business,
      widget.categories,
      widget.start,
      widget.end,
      widget.type,
    );
  }

  popularSort(
    List<QueryDocumentSnapshot<BusinessModel>> business,
    List<String> categories,
    int start,
    int end,
    String type,
  ) async {
    List<Map<String, dynamic>> businessPopular = [];
    try {
      for (QueryDocumentSnapshot<BusinessModel> item in business) {
        if (type == "ร้านอาหาร") {
          int totalOrder = await OrderFoodCollection.ordersOfMonth(
              item.id, categories, start, end);
          if (totalOrder > 0) {
            businessPopular.add({
              "businessName": item.data().businessName,
              "imageRef": item.data().imageRef,
              "score": totalOrder,
            });
          }
        }
        if (type == "ร้านผลิตภัณฑ์") {
          int totalOrder = await OrderProductCollection.ordersOfMonth(
              item.id, categories, start, end);
          if (totalOrder > 0) {
            businessPopular.add({
              "businessName": item.data().businessName,
              "imageRef": item.data().imageRef,
              "score": totalOrder,
            });
          }
        }
        if (type == "บ้านพัก") {
          int totalOrder = await BookingCollection.ordersOfMonth(
              item.id, categories, start, end);
          if (totalOrder > 0) {
            businessPopular.add({
              "businessName": item.data().businessName,
              "imageRef": item.data().imageRef,
              "score": totalOrder,
            });
          }
        }
      }

      businessPopular.sort((a, b) => b["score"].compareTo(a["score"]));
      setState(() {
        sortBusiness = businessPopular;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 1,
      height: height * 0.2,
      child: sortBusiness.isEmpty
          ? Center(
              child: Text("ไม่มี${widget.type}ยอดนิยมประจำเดือนนี้"),
            )
          : ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemCount: sortBusiness.length > 3 ? 3 : sortBusiness.length,
              itemBuilder: (itemBuilder, index) {
                return Card(
                  margin: const EdgeInsets.all(6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    width: width * 0.34,
                    height: height * 0.2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.15,
                          child: ShowImageNetwork(
                            pathImage: sortBusiness[index]["imageRef"],
                            colorImageBlank: MyConstant.colorStore,
                          ),
                        ),
                        Text(
                          sortBusiness[index]["businessName"],
                          style: TextStyle(
                            color: MyConstant.colorStore,
                          ),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
