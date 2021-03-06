import 'package:chanthaburi_app/pages/review/reviews.dart';
import 'package:chanthaburi_app/resources/firestore/review_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:chanthaburi_app/widgets/url_luncher_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailBusiness extends StatefulWidget {
  String businessId, businessName, address, phoneNumber, imageRef;
  num point, ratingCount;
  double lat, lng;
  List<dynamic> policyName;
  List<dynamic> policyDescription;
  DetailBusiness({
    Key? key,
    required this.address,
    required this.businessId,
    required this.businessName,
    required this.lat,
    required this.lng,
    required this.phoneNumber,
    required this.point,
    required this.ratingCount,
    required this.policyDescription,
    required this.policyName,
    required this.imageRef,
  }) : super(key: key);

  @override
  _DetailBusinessState createState() => _DetailBusinessState();
}

class _DetailBusinessState extends State<DetailBusiness> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('รายละเอียดร้าน'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  buildShowMap(width, height,widget.imageRef),
                  buildName(width),
                  buildRowRating(),
                  buildSection(width, 'ข้อมูลทีอยู่ร้าน', widget.address),
                  buildSection(width, 'เบอร์ติดต่อ', widget.phoneNumber),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    width: double.maxFinite,
                    child: const Text("นโยบาย"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    width: double.maxFinite,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: widget.policyName.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.policyName[index]["value"]),
                              Text(widget.policyDescription[index]["value"]),
                              const Divider()
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 15.0,
                  )
                ],
              ),
            ),
            buildCardImageAndReview(width, height)
          ],
        ),
      ),
    );
  }

  Card buildCardImageAndReview(double width, double height) {
    return Card(
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 25, left: 10.0),
                child: Text(
                  'ความคิดเห็น',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<Object>(
              stream: ReviewCollection.reviews(widget.businessId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const InternalError();
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  List<QueryDocumentSnapshot> reviews = snapshot.data!.docs;
                  return buildComment(width, reviews);
                }
                return const PouringHourGlass();
              }),
        ],
      ),
    );
  }

  InkWell buildComment(double width, List<QueryDocumentSnapshot> reviews) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => Reviews(
              listReviews: reviews,
              appBarColor: MyConstant.themeApp,
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
              child: Text('อ่านรีวิว (${reviews.length})'),
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

  SizedBox buildSection(
    double width,
    String typeName,
    String text,
  ) {
    return SizedBox(
      width: width * 1,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  typeName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox buildShowMap(double width, double height,String imageRef) {
    return SizedBox(
      width: width * 1,
      height: height * 0.24,
      child: ShowImageNetwork(colorImageBlank: MyConstant.themeApp,pathImage: imageRef,),
    );
  }

  Container buildName(double width) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
      width: width * 1,
      child: Text(
        widget.businessName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  Row buildRowRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.star,
                color: Colors.yellow[700],
              ),
            ),
            Text(
              '${widget.point != 0.0 && widget.ratingCount != 0.0 ? (widget.point / widget.ratingCount).floor() : 0}(${widget.ratingCount} รีวิว)',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        UrlLuncherMap(
          lat: widget.lat,
          lng: widget.lng,
          businessName: widget.businessName,
        ),
      ],
    );
  }
}
