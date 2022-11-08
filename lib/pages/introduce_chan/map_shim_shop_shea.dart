import 'dart:async';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/pages/introduce_chan/tab_introduce.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/program_travel_collection.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class MapShimShopShea extends StatefulWidget {
  const MapShimShopShea({Key? key}) : super(key: key);

  @override
  State<MapShimShopShea> createState() => _MapShimShopSheaState();
}

class _MapShimShopSheaState extends State<MapShimShopShea> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  fetchAndSetMarker() async {
    Set<Marker> setMarkers = {};
    BitmapDescriptor shimMaker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), MyConstant.shimMarker);
    BitmapDescriptor shopMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), MyConstant.shopMarker);
    BitmapDescriptor sheaMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), MyConstant.sheaMarker);
    List<QueryDocumentSnapshot<BusinessModel>> restaurants =
        await RestaurantCollection.restaurants();
    List<QueryDocumentSnapshot<BusinessModel>> otops =
        await OtopCollection.otops();
    List<QueryDocumentSnapshot<BusinessModel>> alls = [];
    alls.addAll(restaurants);
    alls.addAll(otops);
    for (int i = 0; i < alls.length; i++) {
      QueryDocumentSnapshot<BusinessModel> business = alls[i];
      setMarkers.add(
        Marker(
          markerId: MarkerId(business.id),
          position: LatLng(business.data().latitude, business.data().longitude),
          icon: business.data().visitType == "ชิม"
              ? shimMaker
              : business.data().visitType == "ช็อป"
                  ? shopMarker
                  : sheaMarker,
          infoWindow: InfoWindow(
            title: business.data().businessName,
            snippet: business.data().address,
            onTap: () => MapsLauncher.launchCoordinates(
              business.data().latitude,
              business.data().longitude,
              business.data().businessName,
            ),
          ),
        ),
      );
    }
    setState(() {
      markers = setMarkers;
    });
  }

  void checkPermission() async {
    PermissionStatus locationStatus = await Permission.location.status;
    if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
      alertService(
        context,
        'ไม่อนุญาติแชร์ Location',
        'โปรดแชร์ Location',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    fetchAndSetMarker();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('แนะนำโปรแกรมท่องเที่ยว'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                "แนะนำโปรแกรมท่องเที่ยว",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            StreamBuilder(
              stream: ProgramTravelCollection.programTravels(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<ProgramTravelModel>> snapshot) {
                if (snapshot.hasError) {
                  return const InternalError();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PouringHourGlass();
                }
                List<QueryDocumentSnapshot<ProgramTravelModel>> programs =
                    snapshot.data!.docs;
                return SizedBox(
                  height: height * 0.26,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: programs.length,
                    itemBuilder: (BuildContext context, int index) {
                      ProgramTravelModel program = programs[index].data();
                      return buildCardProgram(
                          width, program, programs[index].id);
                    },
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                "แนะนำสถานที่ ชิม/ช็อป/แชะ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.5,
              width: width * 1,
              child: GoogleMap(
                mapType: MapType.terrain,
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(12.621140, 102.137413),
                  zoom: 14,
                ),
                markers: markers,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCardProgram(
      double width, ProgramTravelModel program, String programId) {
    return Container(
      width: width * 0.8,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TabIntroduce(docId: programId),
              ),
            );
          },
          child: Stack(
            children: [
              SizedBox(
                width: width * 1,
                child: ShowImageNetwork(
                  pathImage: program.imageCover,
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
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 5,
                          ),
                          child: Text(
                            program.programName,
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
