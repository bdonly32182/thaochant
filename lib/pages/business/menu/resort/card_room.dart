import 'package:chanthaburi_app/pages/business/menu/resort/edit_room.dart';
import 'package:flutter/material.dart';

class CardRoom extends StatelessWidget {
  String imageCover, resortId, roomId, categoryId, descriptionRoom, roomName;
  double roomSize, price;
  int totalRoom, totalGuest;
  List<String> listImageDetail;
  CardRoom({
    Key? key,
    required this.roomId,
    required this.roomName,
    required this.price,
    required this.imageCover,
    required this.listImageDetail,
    required this.resortId,
    required this.categoryId,
    required this.descriptionRoom,
    required this.totalRoom,
    required this.roomSize,
    required this.totalGuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRoom(
                    roomId: roomId,
                    roomName: roomName,
                    price: price,
                    imageCover: imageCover,
                    listImageDetail: listImageDetail,
                    resortId: resortId,
                    categoryId: categoryId,
                    descriptionRoom: descriptionRoom,
                    totalRoom: totalRoom,
                    roomSize: roomSize,
                    totalGuest: totalGuest,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                  height: 60,
                  child: imageCover.isNotEmpty
                      ? Image.network(
                          imageCover,
                          fit: BoxFit.fitWidth,
                          width: width * 0.16,
                          height: 20,
                          errorBuilder: (BuildContext buildImageError, object,
                              stackthree) {
                            return SizedBox(
                              width: width * 0.16,
                              child: const Icon(Icons.food_bank),
                            );
                          },
                        )
                      : SizedBox(
                          width: width * 0.16,
                          child: const Icon(Icons.food_bank),
                        ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(roomName),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    Text(price.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
