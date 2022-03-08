import 'package:chanthaburi_app/pages/home/seller/components/business_card.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyResort extends StatefulWidget {
  final String sellerId;
  final bool isAdmin;
  MyResort({Key? key, required this.sellerId, required this.isAdmin,}) : super(key: key);

  @override
  State<MyResort> createState() => _MyResortState();
}

class _MyResortState extends State<MyResort> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: FutureBuilder(
        future: ResortCollection.myResorts(widget.sellerId),
        builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.done) {
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
                    typeBusiness: MyConstant.roomCollection,
                    isAdmin: widget.isAdmin,
                  );
                });
          }
          return const PouringHourGlass();
        },
      ),
    );
  }
}
