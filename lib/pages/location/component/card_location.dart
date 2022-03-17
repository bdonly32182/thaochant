import 'package:chanthaburi_app/pages/location/location_detail.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CardLocation extends StatelessWidget {
  final List<String> listImage;
  final String locationName;
  final num point;
  final num ratingCount;
  final String address;
  final String locationId;
  final bool isAdmin;
  String description;
  String videoRef;
  double lat;
  double lng;
  CardLocation(
      {Key? key,
      required this.listImage,
      required this.locationName,
      required this.point,
      required this.ratingCount,
      required this.address,
      required this.locationId,
      required this.description,
      required this.videoRef,
      required this.isAdmin,
      required this.lat,
      required this.lng})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Colors.red,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => DetailLocation(
                  locationId: locationId,
                  locationName: locationName,
                  address: address,
                  description: description,
                  imageList: listImage,
                  videoRef: videoRef,
                  ratingCount: ratingCount,
                  point: point,
                  isAdmin: isAdmin,
                  lat: lat,
                  lng: lng,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: listImage.isNotEmpty && listImage[0].isNotEmpty
                    ? ShowImageNetwork(
                        pathImage: listImage[0],
                        colorImageBlank: MyConstant.colorLocation,
                      )
                    : SizedBox(
                        width: width * 0.16,
                        child: Icon(
                          Icons.photo_album,
                          size: 50,
                          color: MyConstant.colorLocation,
                        ),
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            width: width * 1,
                            height: height > 730 ? height * .12 : height * .24,
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    locationName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    address,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      RatingBar.builder(
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        initialRating: point / ratingCount,
                                        itemCount:
                                            point != 0.0 && ratingCount != 0.0
                                                ? (point / ratingCount).floor()
                                                : 0,
                                        ignoreGestures: true,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (ratingUpdate) {
                                          print(ratingUpdate);
                                        },
                                      ),
                                      Text(
                                        '($ratingCount)',
                                        style: TextStyle(
                                          color: Colors.amber,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text(
                                      'รายละเอียดเพิ่มเติม >>',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
