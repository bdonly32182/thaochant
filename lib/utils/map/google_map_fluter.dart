import 'dart:async';

import 'package:chanthaburi_app/models/googlemap/google_map.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget {
  final double initLat, initLng;
  const SelectLocation({
    Key? key,
    required this.initLat,
    required this.initLng,
  }) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? position;
  double? lat, lng;
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    Position _position = await determinePosition();
    setState(() {
      lat = _position.latitude;
      lng = _position.longitude;
    });
  }

  final MarkerId _currentMarker = const MarkerId('current_marker');
  Future<void> _goToCurrentPosition(double lat, lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      tilt: 59.440717697143555,
      zoom: 14.4746,
    )));
  }

  void onCameraMove(CameraPosition _position) {
    setState(() {
      lat = _position.target.latitude;
      lng = _position.target.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: lat == null
          ? const PouringHourGlass()
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.terrain,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.initLat, widget.initLng),
                    zoom: 14.4746,
                  ),
                  onCameraMove: onCameraMove,
                  circles: <Circle>{
                    Circle(
                      circleId: const CircleId('circle'),
                      center: LatLng(widget.initLat, widget.initLng),
                      fillColor: Colors.blue.shade200,
                      radius: 200,
                      strokeColor: Colors.blue,
                      strokeWidth: 4,
                    )
                  },
                  markers: <Marker>{
                    Marker(
                      markerId: _currentMarker,
                      position: LatLng(lat!, lng!),
                      draggable: true,
                    ),
                  },
                ),
                buildConfirmPosition(width, context)
              ],
            ),
      floatingActionButton: lat == null
          ? null
          : FloatingActionButton.extended(
              backgroundColor: MyConstant.themeApp,
              onPressed: () =>
                  _goToCurrentPosition(widget.initLat, widget.initLng),
              label: const Text('ตำแหน่งปัจจุบัน'),
              icon: const Icon(Icons.location_searching),
            ),
    );
  }

  Column buildConfirmPosition(double width, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            bottom: 16,
          ),
          width: width * 0.44,
          height: 48,
          child: ElevatedButton(
            child: Text(
              "ยืนยันตำแหน่ง",
              style: TextStyle(
                color: MyConstant.themeApp,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(GoogleMapModel(lat, lng));
            },
            style: ElevatedButton.styleFrom(
              primary: MyConstant.backgroudApp,
              shadowColor: Colors.black38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
