import 'dart:async';
import 'package:chanthaburi_app/models/lets_travel/location_travel.dart';
import 'package:chanthaburi_app/pages/services/buyer_service.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/map/calculate_distance.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class MapAfterFilter extends StatefulWidget {
  const MapAfterFilter({Key? key}) : super(key: key);

  @override
  State<MapAfterFilter> createState() => _MapAfterFilterState();
}

class _MapAfterFilterState extends State<MapAfterFilter> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  double? lat, lng;
  void checkPermission() async {
    try {
      Position positionBuyer = await determinePosition();
      Set<Marker>? respInitMarker =
          await initMarker(positionBuyer.latitude, positionBuyer.longitude);
      setState(() {
        lat = positionBuyer.latitude;
        lng = positionBuyer.longitude;
        if (respInitMarker != null) {
          markers = respInitMarker;
        }
      });
    } catch (e) {
      PermissionStatus locationStatus = await Permission.location.status;
      if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Location',
          'โปรดแชร์ Location',
        );
      }
    }
  }

  Future<Set<Marker>?> initMarker(double lat, double lng) async {
    List<String>? respTravel = await ShareRefferrence.getTravelFilterCurrent();
    if (respTravel != null) {
      List<LocationTravelModel> locations = [];
      for (int i = 0; i < respTravel.length; i++) {
        LocationTravelModel location =
            LocationTravelModel.fromJson(respTravel[i]);
        double distance = CalculateDistance.calculateDistance(
            location.lat, location.lng, lat, lng);
        location.distance =
            distance; // เซ็ทระยะใหม่เพราะว่าบางทียูสเซอร์อาจปิดและเปิดใหม่ ตำแหน่งมันก็เปลี่ยนแล้ว ควรจะเอาตำแหน่ง ณ ปัจจุบันดีกว่า
        locations.add(location);
      }
      locations.sort((a, b) => a.distance.compareTo(b.distance));

      Set<Marker> respMarker = setMarker(locations);
      return respMarker;
    }
    return null;
  }

  Set<Marker> setMarker(List<LocationTravelModel> locations) {
    Set<Marker> setMarkers = {};
    for (var i = 0; i < locations.length; i++) {
      LocationTravelModel location = locations[i];
      var distanceFormat = NumberFormat("###.0#", "en_US");
      setMarkers.add(
        Marker(
          markerId: MarkerId("$i-${location.lat}+${location.lng}"),
          position: LatLng(location.lat, location.lng),
          icon: location.type == "intro"
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: '${location.title}(${i + 1})',
            snippet:
                'ระยะทาง: ${distanceFormat.format(location.distance)} กิโลเมตร',
            onTap: () => MapsLauncher.launchCoordinates(
              location.lat,
              location.lng,
              location.title,
            ),
          ),
        ),
      );
    }
    return setMarkers;
  }

  delTravelFilter() async {
    await ShareRefferrence.delTravelFilterCurrent();
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
    delTravelFilter();
  }

  // 13.756331, 100.501762
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('สถานที่แนะนำสำหรับคุณ'),
        backgroundColor: MyConstant.themeApp,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => BuyerService()),
                (route) => false),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SizedBox(
        width: width * 1,
        height: height * 1,
        child: lat == null || lng == null
            ? const PouringHourGlass()
            : GoogleMap(
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.terrain,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(12.611340, 102.103851),
                  zoom: 14,
                ),
                markers: markers,
              ),
      ),
    );
  }
}
