import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/resort/room.dart';
import 'package:chanthaburi_app/pages/resort/booking_resort.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/image_blank.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomCategory extends StatefulWidget {
  String resortId, categoryId;
  BusinessModel resort;
  int checkIn, checkOut, providerSelectRoom, totalRoom;
  List<dynamic> policyDescription;
  List<dynamic> policyName;
  RoomCategory({
    Key? key,
    required this.categoryId,
    required this.resortId,
    required this.resort,
    required this.checkIn,
    required this.checkOut,
    required this.providerSelectRoom,
    required this.totalRoom,
    required this.policyDescription,
    required this.policyName,
  }) : super(key: key);

  @override
  State<RoomCategory> createState() => _RoomCategoryState();
}

class _RoomCategoryState extends State<RoomCategory> {
  int totalReserve = 1;
  QuerySnapshot<RoomModel>? rooms;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(widget.policyName);
    return StreamBuilder(
      stream: RoomCollection.rooms(widget.resortId, widget.categoryId),
      builder: (context, AsyncSnapshot<QuerySnapshot<RoomModel>> snapshot) {
        if (snapshot.hasError) {
          return const InternalError();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PouringHourGlass();
        }
        return buildListviewRooms(width, height, snapshot.data!.docs);
      },
    );
  }

  ListView buildListviewRooms(double width, double height,
      List<QueryDocumentSnapshot<RoomModel>> rooms) {
    return ListView.builder(
        itemCount: rooms.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (BuildContext buildContext, int index) {
          return FutureBuilder(
              future: BookingCollection.bookingOfRoom(
                  rooms[index].id, widget.checkIn, widget.checkOut),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("เช็คจำนวนห้องพักที่เหลืออยู่ล้มเหลว");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("loading ...");
                }
                int leftRoom =
                    rooms[index].data().totalRoom - snapshot.data!.docs.length;
                return Card(
                  margin: const EdgeInsets.all(5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      buildSwiperImage(width, height, rooms[index].data()),
                      buildShowField(
                        ' ${rooms[index].data().roomName}',
                        Icons.meeting_room,
                      ),
                      buildShowField(
                        'เข้าพักได้สูงสุด : ผู้ใหญ่ ${rooms[index].data().totalGuest} คน',
                        Icons.person,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 12.0),
                            child: Text("ห้องพักเหลืออยู่ $leftRoom ห้อง"),
                          ),
                        ],
                      ),
                      buildFooter(rooms, index, leftRoom, context,
                          widget.policyDescription, widget.policyName)
                    ],
                  ),
                );
              });
        });
  }

  Row buildFooter(
      List<QueryDocumentSnapshot<RoomModel>> rooms,
      int index,
      int leftRoom,
      BuildContext context,
      List<dynamic> policyDescription,
      List<dynamic> policyName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("ราคา ${rooms[index].data().price} ฿"),
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 6),
              child: ElevatedButton(
                onPressed: leftRoom == 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => BookingResort(
                              resort: widget.resort,
                              room: rooms[index].data(),
                              resortId: widget.resortId,
                              totalRoom: widget.totalRoom,
                              roomId: rooms[index].id,
                              providerSelectRoom: widget.providerSelectRoom,
                              policyDescription: policyDescription,
                              policyName: policyName,
                            ),
                          ),
                        );
                      },
                child: const Text("ดูรายละเอียดและจองห้องพัก"),
                style: ElevatedButton.styleFrom(
                  primary: MyConstant.themeApp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row buildShowField(String text, IconData icon) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon),
        ),
        Text(text),
      ],
    );
  }

  SizedBox buildSwiperImage(double width, double height, RoomModel room) {
    return SizedBox(
      width: width * 1,
      height: height * 0.22,
      child: room.listImageDetail.isEmpty
          ? ImageBlank(imageColor: MyConstant.themeApp)
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: room.listImageDetail.length,
              itemBuilder: (context, index) {
                return ShowImageNetwork(
                  pathImage: room.listImageDetail[index],
                  colorImageBlank: MyConstant.themeApp,
                );
              },
            ),
    );
  }
}
