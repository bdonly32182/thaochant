import 'package:chanthaburi_app/models/location/location.dart';
import 'package:chanthaburi_app/pages/location/edit_location.dart';
import 'package:chanthaburi_app/pages/review/reviews.dart';
import 'package:chanthaburi_app/pages/review/write_review.dart';
import 'package:chanthaburi_app/resources/firestore/review_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/image_blank.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_login.dart';

class DetailLocation extends StatefulWidget {
  final String locationId;
  final String locationName;
  final String description;
  final String address;
  final List<String> imageList;
  final String videoRef;
  final num ratingCount;
  final num point;
  final bool isAdmin;
  final double lat;
  final double lng;
  const DetailLocation(
      {Key? key,
      required this.locationId,
      required this.locationName,
      required this.address,
      required this.description,
      required this.imageList,
      required this.videoRef,
      required this.ratingCount,
      required this.point,
      required this.isAdmin,
      required this.lat,
      required this.lng})
      : super(key: key);

  @override
  State<DetailLocation> createState() => _DetailLocationState();
}

class _DetailLocationState extends State<DetailLocation> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.colorLocation,
        title: const Text('รายละเอียดแหล่งท่องเที่ยว'),
        actions: widget.isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => EditLocation(
                          locationId: widget.locationId,
                          locationModel: LocationModel(
                            locationName: widget.locationName,
                            address: widget.address,
                            description: widget.description,
                            imageList: widget.imageList,
                            videoRef: widget.videoRef,
                            ratingCount: widget.ratingCount,
                            point: widget.point,
                            lat: widget.lat,
                            lng: widget.lng,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.mode_edit_outlined,
                    size: 30,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    String userId = AuthMethods.currentUser();
                    if (userId.isEmpty) {
                      dialogLogin(context);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => WriteReview(
                          businessId: widget.locationId,
                          businessName: widget.locationName,
                          businessImage: widget.imageList[0],
                          theme: MyConstant.colorLocation,
                          type: "location",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.mode_edit_outlined,
                    size: 30,
                  ),
                ),
              ],
      ),
      body: StreamBuilder(
        stream: ReviewCollection.reviews(widget.locationId),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            List<QueryDocumentSnapshot> reviews = snapshot.data!.docs;
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildShowImageLocation(width, height),
                  buildCardDetail(
                    widget.point,
                    widget.ratingCount,
                    snapshot.data!.size,
                  ),
                  Card(
                      child: Column(
                    children: [
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 25, left: 10.0),
                            child: Text(
                              'ความคิดเห็นทั้งหมด',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // buildShowImageReview(width, height, reviews),
                      buildComment(width, snapshot.data!.size, reviews),
                    ],
                  ))
                ],
              ),
            );
          }
          return const PouringHourGlass();
        },
      ),
    );
  }

  Container buildShowImageReview(
      double width, double height, List<QueryDocumentSnapshot> reviews) {
    List reviewHasImage =
        reviews.where((review) => review["imageRef"] != "").toList();
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: width * 1,
      height: height * 0.16,
      child: reviews.isEmpty
          ? const Center(
              child: Text(
              'ไม่มีรีวิว',
              style: TextStyle(
                fontSize: 18,
              ),
            ))
          : reviewHasImage.isNotEmpty
              ? ListView.builder(
                  itemCount: reviewHasImage.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(3.0),
                      width: width * 0.22,
                      height: 70,
                      child: ShowImageNetwork(
                        pathImage: reviewHasImage[index]["imageRef"],
                        colorImageBlank: MyConstant.colorLocation,
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                  'ไม่มีรูปภาพ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )),
    );
  }

  InkWell buildComment(
      double width, int reviewSize, List<QueryDocumentSnapshot> reviews) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => Reviews(
              listReviews: reviews,
              appBarColor: MyConstant.colorLocation,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: width * 1,
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('อ่านรีวิว ($reviewSize)'),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15,
            )
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
              offset: Offset(0, 0.5),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Card buildCardDetail(num point, num ratingCount, int reviewSize) {
    return Card(
      child: Column(
        children: [
          buildNameLocation(),
          buildRating(point, ratingCount, reviewSize),
          buildAddress(),
          buildNameDescription(),
          buildDescription(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Row buildDescription() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.description,
            style: const TextStyle(
              fontSize: 15,
            ),
            maxLines: 15,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Row buildNameDescription() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'รายละเอียด',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Row buildAddress() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5.0),
            child: Text(
              widget.address,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Row buildRating(num point, num ratingCount, int reviewSize) {
    int rating =
        point != 0.0 && ratingCount != 0.0 ? (point / ratingCount).floor() : 0;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(
            Icons.star,
            size: 15,
            color: Colors.yellow[700],
          ),
        ),
        Text('$rating ($reviewSize รีวิว)'),
      ],
    );
  }

  Row buildNameLocation() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.locationName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox buildShowImageLocation(double width, double height) {
    return SizedBox(
      width: width * 1,
      height: height * 0.26,
      child: widget.imageList.isNotEmpty
          ? ListView.builder(
              itemCount: widget.imageList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(
                    right: 5,
                  ),
                  child: ShowImageNetwork(
                    pathImage: widget.imageList[index],
                    colorImageBlank: const Color.fromRGBO(159, 156, 213, 0.7),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: SizedBox(
                    width: width * 1,
                    height: height * 0.26,
                    child: ImageBlank(
                      imageColor: const Color.fromRGBO(159, 156, 213, 0.7),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
