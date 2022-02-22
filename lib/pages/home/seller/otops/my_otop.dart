import 'package:chanthaburi_app/pages/home/seller/components/business_card.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOtop extends StatefulWidget {
  String sellerId;

  MyOtop({Key? key, required this.sellerId})
      : super(key: key);

  @override
  State<MyOtop> createState() => _MyOtopState();
}

class _MyOtopState extends State<MyOtop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: FutureBuilder(
        future: OtopCollection.myOtops(widget.sellerId),
        builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.docs.isEmpty) {
              return const ShowDataEmpty();
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (itemBuilder, index) {
                  return BusinessCard(
                    sellerId: snapshot.data!.docs[index]['sellerId'],
                    businessName: snapshot.data!.docs[index]['businessName'],
                    businessId: snapshot.data!.docs[index].id,
                    typeBusiness: MyConstant.productOtopCollection,
                  );
                });
          }
          return const PouringHourGlass();
        },
      ),
    );
  }
}
