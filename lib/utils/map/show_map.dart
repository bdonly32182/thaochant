import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  final double lat, lng;
  const ShowMap({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.terrain,
      scrollGesturesEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.lat, widget.lng),
        zoom: 12.0,
      ),
      markers: <Marker>{
        Marker(
          markerId: const MarkerId("position"),
          position: LatLng(widget.lat, widget.lng),
        ),
      },
    );
  }
}
