import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/pages/resort/resort_detail.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShoppingResort extends StatefulWidget {
  int totalRoom, totalParticipant, checkIn, checkOut;
  ShoppingResort({
    Key? key,
    required this.checkIn,
    required this.checkOut,
    required this.totalParticipant,
    required this.totalRoom,
  }) : super(key: key);

  @override
  State<ShoppingResort> createState() => _ShoppingResortState();
}

class _ShoppingResortState extends State<ShoppingResort> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text("ผลลัพธ์การค้นหา"),
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: FutureBuilder(
          future: ResortCollection.resortReadyCheckIn(widget.totalRoom,
              widget.totalParticipant, widget.checkIn, widget.checkOut),
          builder: (context,
              AsyncSnapshot<List<QueryDocumentSnapshot<BusinessModel>>>
                  snapshot) {
            if (snapshot.hasError) {
              return const InternalError();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PouringHourGlass();
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: ShowDataEmpty(),
              );
            }
            return buildListView(height, width, snapshot.data!);
          },
        ),
      ),
    );
  }

  ListView buildListView(double height, double width,
      List<QueryDocumentSnapshot<BusinessModel>> resorts) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: resorts.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResortDetail(
                      resortId: resorts[index].id,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  buildImageCard(width, height, resorts[index].data()),
                  buildResortName(resorts[index].data()),
                  buildResortLocation(resorts[index].data()),
                  const SizedBox(
                    height: 10,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.05,
                    ),
                  ),
                  buildFooter(resorts[index].data())
                ],
              ),
            ),
          );
        });
  }

  Row buildFooter(BusinessModel resort) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 6),
          child: Row(
            children: [
              Icon(Icons.payments_outlined, color: Colors.red[200]),
              Text(
                'จ่ายล่วงหน้า 50 %',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade300,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: Row(
            children: [
              RatingBar.builder(
                itemSize: 20.0,
                initialRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                ignoreGestures: true,
                itemCount: 1,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (ratingUpdate) {
                  print(ratingUpdate);
                },
              ),
              Text(
                (resort.point != 0.0 && resort.ratingCount != 0.0
                        ? (resort.point / resort.ratingCount).floor()
                        : 0)
                    .toString(),
              ),
              Text("(${resort.ratingCount})")
            ],
          ),
        ),
      ],
    );
  }

  Row buildResortLocation(BusinessModel resort) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              resort.address,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 15),
          child: Text(
            'ต่อคืน',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Row buildResortName(BusinessModel resort) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              resort.businessName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${resort.startPrice} ฿",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox buildImageCard(double width, double height, BusinessModel resort) {
    return SizedBox(
      width: width * 1,
      height: height * 0.14,
      child: ShowImageNetwork(
        colorImageBlank: MyConstant.themeApp,
        pathImage: resort.imageRef,
      ),
    );
  }
}
