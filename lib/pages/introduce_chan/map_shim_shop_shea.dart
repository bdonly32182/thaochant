import 'dart:async';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/routes.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapShimShopShea extends StatefulWidget {
  MapShimShopShea({Key? key}) : super(key: key);

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
    List<QueryDocumentSnapshot<BusinessModel>> restaurants =
        await RestaurantCollection.restaurants();
    List<QueryDocumentSnapshot<BusinessModel>> otops =
        await OtopCollection.otops();
    for (int i = 0; i < restaurants.length; i++) {
      QueryDocumentSnapshot<BusinessModel> shim = restaurants[i];
      setMarkers.add(
        Marker(
          markerId: MarkerId(shim.id),
          position: LatLng(shim.data().latitude, shim.data().longitude),
          icon: shimMaker,
          infoWindow: InfoWindow(
            title: shim.data().businessName,
            snippet: shim.data().address,
            onTap: () => MapsLauncher.launchCoordinates(
              shim.data().latitude,
              shim.data().longitude,
              shim.data().businessName,
            ),
          ),
        ),
      );
    }
    for (int i = 0; i < otops.length; i++) {
      QueryDocumentSnapshot<BusinessModel> shop = otops[i];
      setMarkers.add(
        Marker(
          markerId: MarkerId(shop.id),
          position: LatLng(shop.data().latitude, shop.data().longitude),
          icon: shopMarker,
          infoWindow: InfoWindow(
            title: shop.data().businessName,
            snippet: shop.data().address,
            onTap: () => MapsLauncher.launchCoordinates(
              shop.data().latitude,
              shop.data().longitude,
              shop.data().businessName,
            ),
          ),
        ),
      );
    }
    setState(() {
      markers = setMarkers;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetMarker();
  }

  @override
  Widget build(BuildContext context) {
    print(Routes.navigatorKey);
    return GoogleMap(
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
    );
  }
}
