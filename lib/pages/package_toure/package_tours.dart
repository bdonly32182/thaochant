import 'package:chanthaburi_app/models/packagetour/package_tour.dart';
import 'package:chanthaburi_app/pages/package_toure/create_package_toure.dart';
import 'package:chanthaburi_app/pages/package_toure/edit_package_tour.dart';
import 'package:chanthaburi_app/pages/package_toure/package_detail.dart';
import 'package:chanthaburi_app/resources/firestore/tour_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PackageTours extends StatefulWidget {
  bool isAdmin;
  bool isBuyer;
  PackageTours({Key? key, required this.isAdmin, required this.isBuyer})
      : super(key: key);

  @override
  State<PackageTours> createState() => _PackageToursState();
}

class _PackageToursState extends State<PackageTours> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('แพ็คเกจท่องเที่ยว'),
        actions: widget.isAdmin
            ? <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreatePackageTour(),
                      ),
                    );
                  },
                )
              ]
            : [],
      ),
      body: StreamBuilder(
        stream: TourCollection.tours(widget.isAdmin),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<PackageTourModel>> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          List<QueryDocumentSnapshot<PackageTourModel>> packageTours =
              snapshot.data!.docs;
          return ListView.builder(
              itemCount: packageTours.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: height * .32,
                  child: buildCardPackage(
                    size,
                    height,
                    packageTours[index].data(),
                    packageTours[index].id,
                  ),
                );
              });
        },
      ),
    );
  }

  Container buildCardPackage(
      double width, double height, PackageTourModel tour, String tourId) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 17),
            blurRadius: 17,
            spreadRadius: -22,
            color: Colors.grey,
          ),
        ],
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            if (widget.isAdmin) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => EditPackageTour(
                    tour: tour,
                    tourId: tourId,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => PackageDetail(
                    tour: tour,
                    tourId: tourId,
                    isBuyer: widget.isBuyer,
                  ),
                ),
              );
            }
          },
          child: Stack(
            children: [
              SizedBox(
                width: width * 1,
                child: ShowImageNetwork(
                  pathImage: tour.imageRef,
                  colorImageBlank: MyConstant.colorGuide,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width * 1,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Text(
                            tour.packageName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 25),
                          width: double.maxFinite,
                          child: Text(
                            tour.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ราคา ${tour.priceAdult} บาท',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.yellow[600],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  children: const [
                                    Text(
                                      "ดูข้อมูลเพิ่มเติม",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.navigate_next_sharp,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
