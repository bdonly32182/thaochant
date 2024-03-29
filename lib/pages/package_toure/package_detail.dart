import 'package:chanthaburi_app/models/packagetour/id_name.dart';
import 'package:chanthaburi_app/models/packagetour/package_tour.dart';
import 'package:chanthaburi_app/pages/package_toure/booking_tour.dart';
import 'package:chanthaburi_app/pages/package_toure/preview_pdf.dart';
import 'package:chanthaburi_app/pages/review/write_review.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/tour_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_login.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PackageDetail extends StatefulWidget {
  PackageTourModel tour;
  String tourId;
  bool isBuyer;
  PackageDetail(
      {Key? key,
      required this.tour,
      required this.tourId,
      required this.isBuyer})
      : super(key: key);

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyConstant.backgroudApp,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildImagePackage(
                    width,
                    height,
                    widget.tour.imageRef,
                    widget.tour.packageName,
                    widget.tour.point,
                    widget.tour.ratingCount,
                    // widget.tour.locations[0].name,
                  ),
                  buildDescriptPackage(
                    widget.tour.description,
                    widget.tour.pdfRef,
                    widget.tour.packageName,
                  ),
                  // buildTitleGallery("Preview's Locations"),
                  // buildTravelGallery(width, height,
                  //  widget.tour.locations
                  //  ),
                  // buildTitleGallery("Preview's Resort"),
                  // buildShowResort(width, height, widget.tour.resorts)
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: height * 0.1,
              child: widget.isBuyer
                  ? buildTabBooking(
                      height,
                      widget.tour.priceAdult,
                      widget.tour.imageRef,
                      widget.tour.packageName,
                      widget.tour.priceOlder,
                      widget.tour.priceYouth,
                      widget.tourId,
                    )
                  : buildTabWriteReview(
                      height,
                      widget.tour.status,
                      widget.tourId,
                      widget.tour.packageName,
                      widget.tour.imageRef),
              decoration: BoxDecoration(
                color: MyConstant.themeApp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildTabWriteReview(double height, int status, String docId,
      String packageName, String imageRef) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'สถานะแพ็คเกจ',
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
              ),
            ),
            ToggleSwitch(
              totalSwitches: 2,
              minWidth: 50.0,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.red.shade600],
                [MyConstant.colorStore],
              ],
              labels: const ['ปิด', 'เปิด'],
              activeFgColor: Colors.white,
              inactiveBgColor: MyConstant.backgroudApp,
              inactiveFgColor: Colors.grey,
              initialLabelIndex: status,
              radiusStyle: true,
              onToggle: (index) {
                if (status != index) {
                  TourCollection.updateStatus(docId, index);
                }
              },
            ),
          ],
        ),
        ElevatedButton(
          child: Text(
            'เขียนรีวิว',
            style: TextStyle(fontSize: 16, color: MyConstant.themeApp),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => WriteReview(
                  businessId: docId,
                  businessName: packageName,
                  businessImage: imageRef,
                  theme: MyConstant.themeApp,
                  type: "tour",
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(primary: Colors.white),
        ),
      ],
    );
  }

  Row buildTabBooking(double height, double priceAdult, String imageRef,
      packageName, double priceSenior, priceYouth, String tourId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ราคาเฉลี่ย',
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16,
              ),
            ),
            Text(
              '$priceAdult ฿',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ElevatedButton(
          child: Text(
            'Booking now',
            style: TextStyle(fontSize: 16, color: MyConstant.themeApp),
          ),
          onPressed: () {
            String userId = AuthMethods.currentUser();
            if (userId.isEmpty) {
              dialogLogin(context);
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => BookingTour(
                  imageRef: imageRef,
                  packageName: packageName,
                  priceAdult: priceAdult,
                  priceSenior: priceSenior,
                  priceYouth: priceYouth,
                  tourId: tourId,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(primary: Colors.white),
        ),
      ],
    );
  }

  SizedBox buildShowResort(
      double width, double height, List<IdAndName> resorts) {
    return SizedBox(
      width: width * 1,
      height: height * 0.24,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: resorts.length,
          itemBuilder: (BuildContext galleryContext, int index) {
            return Container(
              width: width * 0.4,
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ShowImageNetwork(
                        pathImage: resorts[index].imageRef,
                        colorImageBlank: MyConstant.colorGuide),
                  ),
                  Text(
                    resorts[index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }),
    );
  }

  SizedBox buildTravelGallery(
      double width, double height, List<IdAndName> locations) {
    return SizedBox(
      width: width * 1,
      height: height * 0.24,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: locations.length,
          itemBuilder: (BuildContext galleryContext, int index) {
            return Container(
              width: width * 0.4,
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ShowImageNetwork(
                        pathImage: locations[index].imageRef,
                        colorImageBlank: MyConstant.colorGuide),
                  ),
                  Text(
                    locations[index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Container buildTitleGallery(String title) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding buildDescriptPackage(
      String description, String urlPdf, String packageName) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: urlPdf.isEmpty
                      ? () => dialogAlert(context, "ประกาศ", "ไม่มีไฟล์ pdf")
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) =>
                                  PreviewPdf(url: urlPdf, name: packageName),
                            ),
                          );
                        },
                  child: const Text(
                    "ดูข้อมูลเพิ่มเติม(PDF)",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildImagePackage(
    double width,
    double height,
    String imageRef,
    String packageName,
    double point,
    double ratingCount,
    // String locationSugguest
  ) {
    return Container(
      width: width * 1,
      height: height * 0.3,
      child: Stack(
        children: [
          ShowImageNetwork(
            colorImageBlank: MyConstant.colorGuide,
            pathImage: imageRef,
          ),
          buildArrowBack(),
          buildColumnInImage(
            height,
            packageName, point, ratingCount,
            // locationSugguest
          ),
        ],
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  Row buildArrowBack() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 10),
            child: const Center(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Column buildColumnInImage(
    double height,
    String packageName,
    double point,
    double ratingCount,
    // String locationSugguest
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          // margin: const EdgeInsets.all(8),
          width: double.maxFinite,
          height: height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    packageName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber[600],
                    ),
                    Text(
                      (point != 0.0 && ratingCount != 0.0
                              ? (point / ratingCount).floor()
                              : 0)
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "($ratingCount)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(
        //     bottom: 15.0,
        //     left: 8.0,
        //   ),
        //   child: Row(
        //     children: [
        //       const Icon(
        //         Icons.location_on_outlined,
        //         color: Colors.white70,
        //       ),
        //       Text(
        //         "$locationSugguest และ อื่นๆ",
        //         style: const TextStyle(
        //           color: Colors.white70,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Row buildStartAndEndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: const [
            Icon(Icons.calendar_today),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'พ., ธ.ค. 29',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const Icon(Icons.arrow_forward),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'พฤ., ธ.ค. 30',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.dark_mode),
            ),
            Text('1 คืน'),
          ],
        )
      ],
    );
  }
}
