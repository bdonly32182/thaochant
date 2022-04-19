import 'package:chanthaburi_app/models/sqlite/order_product.dart';
import 'package:chanthaburi_app/pages/otop/product.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class CategoryOtop extends StatefulWidget {
  final String businessId,otopName;
  List<ProductCartModel> products;
  int status;
  CategoryOtop({Key? key,required this.businessId,required this.products, required this.otopName,required this.status}) : super(key: key);

  @override
  State<CategoryOtop> createState() => _CategoryOtopState();
}

class _CategoryOtopState extends State<CategoryOtop> {
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
              return Product(
                businessId: widget.businessId,
                categoryId: snapshot.data!.docs[index].id,
                categoryName: snapshot.data!.docs[index]["categoryName"],
                otopName: widget.otopName,
                products: widget.products,
                status: widget.status,
              );
            },
          );
        }
        return const PouringHourGlass();
      },
    );
  }
}