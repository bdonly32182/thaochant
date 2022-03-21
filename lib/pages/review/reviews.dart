import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  List<QueryDocumentSnapshot> listReviews;
  Color appBarColor;
  Reviews({Key? key, required this.listReviews, required this.appBarColor})
      : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('ความคิดเห็น'),
        backgroundColor: widget.appBarColor,
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: widget.listReviews.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                  future: UserCollection.profile(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Card(
                        child: Column(
                          children: [
                            buildRowImageAndRating(
                              width,
                              snapshot.data!.get("fullName"),
                              widget.listReviews[index]["point"],
                            ),

                            // buildShowImage(
                            //   width,
                            //   widget.listReviews[index]['imageRef'],
                            // ),
                            SizedBox(
                              width: width * 1,
                              child: Column(
                                children: [
                                  buildMessage(width,
                                      widget.listReviews[index]['message']),
                                  buildDateReview(width,
                                      widget.listReviews[index]["dateTime"]),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  });
            },
          ),
        ],
      ),
    );
  }

  Container buildDateReview(
    double width,
    Timestamp timestamp,
  ) {
    DateTime dateTime = timestamp.toDate();
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 8.0, bottom: 6.0),
      width: width * 0.7,
      child: Text('${dateTime.year}-${dateTime.month}-${dateTime.day} '),
    );
  }

  Container buildShowImage(double width, String imageReview) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      width: width * 0.2,
      child: ShowImageNetwork(
        colorImageBlank: widget.appBarColor,
        pathImage: imageReview,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 0.8),
          ),
        ],
      ),
    );
  }

  Container buildMessage(double width, String message) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, top: 12.0),
      width: width * 0.7,
      child: Text(
        message,
        maxLines: 10,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Container buildTextTitle(double width, String title) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      width: width * 1,
      child: Text(
        title,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row buildRowImageAndRating(double width, String nameUser, double point) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          width: width * 0.09,
          height: 35,
          child: Icon(
            Icons.person,
            color: widget.appBarColor,
          ),
          decoration: BoxDecoration(
            color: MyConstant.backgroudApp,
            shape: BoxShape.circle,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15.0, left: 6.0),
                  width: width * 0.7,
                  child: Text(
                    nameUser,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            buildListShowStar(width, point),
          ],
        ),
      ],
    );
  }

  Container buildListShowStar(double width, double point) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, left: 6.0),
      width: width * 0.8,
      height: 20,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: point.toInt(),
        itemBuilder: (BuildContext starContext, int index) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            width: 16,
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 15,
            ),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
