import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/restaurant/component/food.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryRestaurant extends StatefulWidget {
  final String businessId, restaurantName;
  final List<ProductCartModel> foods;
  final int status;
  final List<TimeTurnOnOfModel> times;
  const CategoryRestaurant({
    Key? key,
    required this.businessId,
    required this.restaurantName,
    required this.foods,
    required this.status,
    required this.times,
  }) : super(key: key);

  @override
  State<CategoryRestaurant> createState() => _CategoryRestaurantState();
}

class _CategoryRestaurantState extends State<CategoryRestaurant> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CategoryCollection.streamCategorys(widget.businessId),
      builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const InternalError();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: ShowDataEmpty());
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (itemBuilder, index) {
              return Food(
                businessId: widget.businessId,
                categoryId: snapshot.data!.docs[index].id,
                categoryName: snapshot.data!.docs[index]["categoryName"],
                restaurantName: widget.restaurantName,
                foods: widget.foods,
                status: widget.status,
                times: widget.times,
              );
            },
          );
        }
        return const PouringHourGlass();
      },
    );
  }
}
