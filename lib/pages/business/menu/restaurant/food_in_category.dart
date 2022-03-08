import 'package:chanthaburi_app/pages/business/menu/restaurant/card_food.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodInCategory extends StatefulWidget {
  String businessId, categoryId, categoryName;
  FoodInCategory({
    Key? key,
    required this.businessId,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<FoodInCategory> createState() => _FoodInCategoryState();
}

class _FoodInCategoryState extends State<FoodInCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.categoryName,
                  style: TextStyle(
                    color: MyConstant.colorStore,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: FoodCollection.foods(widget.businessId, widget.categoryId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('เกิดเหตุขัดข้อง');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Text('ไม่มีข้อมูลสินค้า');
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  return CardFood(
                    foodId: snapshot.data!.docs[index].id,
                    foodName: snapshot.data!.docs[index]['foodName'],
                    price: snapshot.data!.docs[index]['price'],
                    imageRef: snapshot.data!.docs[index]['imageRef'],
                    restaurantId: snapshot.data!.docs[index]['restaurantId'],
                    categoryId: snapshot.data!.docs[index]['categoryId'],
                    description: snapshot.data!.docs[index]['description'],
                    status: snapshot.data!.docs[index]['status'],
                    optionId: List<String>.from(
                      snapshot.data!.docs[index]['optionId'],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 0.4),
          ),
        ],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
