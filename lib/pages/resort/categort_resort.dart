import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/pages/resort/room.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryResort extends StatefulWidget {
  String resortId;
  BusinessModel resort;
  int checkIn, checkOut, providerSelectRoom, totalRoom;
  CategoryResort({
    Key? key,
    required this.resortId,
    required this.resort,
    required this.checkIn,
    required this.checkOut,
    required this.providerSelectRoom,
    required this.totalRoom,
  }) : super(key: key);

  @override
  State<CategoryResort> createState() => _CategoryResortState();
}

class _CategoryResortState extends State<CategoryResort> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CategoryCollection.streamCategorys(widget.resortId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const InternalError();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PouringHourGlass();
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ประเภทห้องพัก : ${snapshot.data!.docs[index]["categoryName"]}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                RoomCategory(
                  categoryId: snapshot.data!.docs[index].id,
                  resortId: widget.resortId,
                  resort: widget.resort,
                  checkOut: widget.checkOut,
                  checkIn: widget.checkIn,
                  providerSelectRoom: widget.providerSelectRoom,
                  totalRoom: widget.totalRoom,
                  policyDescription: widget.resort.policyDescription,
                  policyName: widget.resort.policyName,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
