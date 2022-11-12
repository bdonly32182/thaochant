import 'dart:async';

import 'package:chanthaburi_app/models/program_travel/location_program.dart';
import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapProgramTravel extends StatefulWidget {
  final ProgramTravelModel programTravel;
  const MapProgramTravel({
    Key? key,
    required this.programTravel,
  }) : super(key: key);

  @override
  State<MapProgramTravel> createState() => _MapProgramTravelState();
}

class _MapProgramTravelState extends State<MapProgramTravel> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  String selectDay = "";
  double? initLat, initLng;
  List<DropdownMenuItem<String>> daysItem =
      [""].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Text(
          value,
          style: TextStyle(
            color: MyConstant.themeApp,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }).toList();
  initMarker(ProgramTravelModel program) {
    if (program.dayIdList.isEmpty) {
      return;
    }
    String dayFirst = program.dayIdList.first;
    List<LocationProgramModel> initLocations =
        program.location.where((element) => element.dayId == dayFirst).toList();
    Set<Marker> respMarker = setMarker(initLocations);
    List<DropdownMenuItem<String>> dropdownItems = List.generate(
      program.dayIdList.length,
      (index) => DropdownMenuItem(
        value: program.dayIdList[index],
        child: Text("วันที่ ${index + 1}",
            style: TextStyle(
              color: MyConstant.themeApp,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
    setState(() {
      markers = respMarker;
      selectDay = dayFirst;
      daysItem = dropdownItems;
      initLng = program.location[0].lng;
      initLat = program.location[0].lat;
    });
  }

  Set<Marker> setMarker(List<LocationProgramModel> locations) {
    Set<Marker> setMarkers = {};
    for (var i = 0; i < locations.length; i++) {
      LocationProgramModel locationModel = locations[i];
      setMarkers.add(
        Marker(
          markerId: MarkerId(
              "${locationModel.dayId}-$i-${locationModel.lat}+${locationModel.lng}"),
          position: LatLng(locationModel.lat, locationModel.lng),
          infoWindow: InfoWindow(
            title: locationModel.locationName,
            snippet: 'รอบ ${locationModel.time}',
            onTap: () => MapsLauncher.launchCoordinates(
              locationModel.lat,
              locationModel.lng,
              locationModel.locationName,
            ),
          ),
        ),
      );
    }
    return setMarkers;
  }

  onChangeDay(String? dayId) {
    if (dayId != null) {
      List<LocationProgramModel> initLocations = widget.programTravel.location
          .where((element) => element.dayId == dayId)
          .toList();
      Set<Marker> respMarker = setMarker(initLocations);
      setState(() {
        markers = respMarker;
        selectDay = dayId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initMarker(widget.programTravel);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 1,
      height: height * 1,
      child: initLat == null && initLng == null
          ? const PouringHourGlass()
          : Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.terrain,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(initLat ?? 12.621140, initLng ?? 102.137413),
                    zoom: 14,
                  ),
                  markers: markers,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: width * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        style: TextStyle(color: MyConstant.themeApp),
                        value: selectDay,
                        items: daysItem,
                        onChanged: onChangeDay,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
