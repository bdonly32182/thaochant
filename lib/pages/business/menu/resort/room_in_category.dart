import 'package:chanthaburi_app/pages/business/menu/resort/card_room.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomInCategory extends StatefulWidget {
  String categoryName, businessId, categoryId;
  RoomInCategory(
      {Key? key,
      required this.categoryName,
      required this.businessId,
      required this.categoryId})
      : super(key: key);

  @override
  State<RoomInCategory> createState() => _RoomInCategoryState();
}

class _RoomInCategoryState extends State<RoomInCategory> {
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
            stream: RoomCollection.rooms(widget.businessId, widget.categoryId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('เกิดเหตุขัดข้อง');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Text('ไม่มีข้อมูลห้องพัก');
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  return CardRoom(
                    roomId: snapshot.data!.docs[index].id,
                    roomName: snapshot.data!.docs[index]['roomName'],
                    price: snapshot.data!.docs[index]['price'],
                    imageCover: snapshot.data!.docs[index]['imageCover'],
                    listImageDetail: List<String>.from(
                      snapshot.data!.docs[index]['listImageDetail'],
                    ),
                    resortId: snapshot.data!.docs[index]['resortId'],
                    categoryId: snapshot.data!.docs[index]['categoryId'],
                    descriptionRoom: snapshot.data!.docs[index]
                        ['descriptionRoom'],
                    totalRoom: snapshot.data!.docs[index]['totalRoom'],
                    roomSize: snapshot.data!.docs[index]['roomSize'],
                    totalGuest: snapshot.data!.docs[index]['totalGuest'],
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
