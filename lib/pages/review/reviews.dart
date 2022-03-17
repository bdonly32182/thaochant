import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
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
        title: const Center(child: Text('รีวิว')),
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
                                widget.listReviews[index]["dateTime"],
                                widget.listReviews[index]["point"]),
                            buildTextTitle(
                              width,
                              widget.listReviews[index]['title'],
                            ),
                            buildMessage(
                              width,
                              widget.listReviews[index]['message'],
                            ),
                            // buildShowImage(
                            //   width,
                            //   widget.listReviews[index]['imageRef'],
                            // ),
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
      margin: const EdgeInsets.only(left: 10.0),
      width: width * 1,
      child: Text(
        message,
        maxLines: 10,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
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

  Row buildRowImageAndRating(
      double width, String nameUser, Timestamp timestamp, double point) {
    DateTime dateTime = timestamp.toDate();
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          width: width * 0.1,
          height: 40,
          child: ShowImage(pathImage: MyConstant.iconUser),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: width * 0.5,
                  child: Text(nameUser),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: width * 0.3,
                  child: Text(
                      '${dateTime.year}-${dateTime.month}-${dateTime.day} '),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 6.0),
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
            ),
          ],
        ),
      ],
    );
  }
}
