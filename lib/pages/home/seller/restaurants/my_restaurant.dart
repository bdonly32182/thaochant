import 'package:chanthaburi_app/pages/home/seller/components/business_card.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyRestaurant extends StatefulWidget {
  String sellerId;
  bool isAdmin;
  MyRestaurant({
    Key? key,
    required this.sellerId,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<MyRestaurant> createState() => _MyRestaurantState();
}

class _MyRestaurantState extends State<MyRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: StreamBuilder(
        stream: RestaurantCollection.myRestaurants(widget.sellerId),
        builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: ShowDataEmpty());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (itemBuilder, index) {
                  return BusinessCard(
                    sellerId: snapshot.data!.docs[index]['sellerId'],
                    businessName: snapshot.data!.docs[index]['businessName'],
                    businessId: snapshot.data!.docs[index].id,
                    typeBusiness: MyConstant.foodCollection,
                    isAdmin: widget.isAdmin,
                    imageRef: snapshot.data!.docs[index]['imageRef'],
                  );
                });
          }
          return const PouringHourGlass();
        },
      ),
    );
  }
}
