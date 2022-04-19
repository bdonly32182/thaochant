import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class UrlLuncherMap extends StatelessWidget {
  double lat, lng;
  String businessName;
  UrlLuncherMap(
      {Key? key,
      required this.lat,
      required this.lng,
      required this.businessName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        MapsLauncher.launchCoordinates(lat, lng, businessName);
      },
      child: Row(
        children: [
          const Text(
            "เส้นทางเพิ่มเติม",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              decoration: TextDecoration.underline,
            ),
          ),
          Icon(
            Icons.directions,
            color: Colors.amber[700],
          ),
        ],
      ),
    );
  }
}
