import 'dart:convert';


class LocationTravelModel {
  double lat;
  String title;
  double lng;
  String snippet;
  double distance;
  String type;
  LocationTravelModel({
    required this.lat,
    required this.title,
    required this.lng,
    required this.snippet,
    required this.distance,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'title': title,
      'lng': lng,
      'snippet': snippet,
      'distance': distance,
      'type': type,
    };
  }

  factory LocationTravelModel.fromMap(Map<String, dynamic> map) {
    return LocationTravelModel(
      lat: map['lat']?.toDouble() ?? 0.0,
      title: map['title'] ?? '',
      lng: map['lng']?.toDouble() ?? 0.0,
      snippet: map['snippet'] ?? '',
      distance: map['distance']?.toDouble() ?? 0.0,
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationTravelModel.fromJson(String source) =>
      LocationTravelModel.fromMap(json.decode(source));
}
