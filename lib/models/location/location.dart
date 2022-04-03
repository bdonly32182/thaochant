import 'dart:convert';

import 'package:flutter/foundation.dart';

class LocationModel {
  String locationName;
  String address; 
  String description;
  List<String> imageList; 
  String videoRef;
  num ratingCount;
  num point;
  double lat;
  double lng;
  LocationModel({
    required this.locationName,
    required this.address,
    required this.description,
    required this.imageList,
    required this.videoRef,
    required this.ratingCount,
    required this.point,
    required this.lat,
    required this.lng,
  });
  
  

  LocationModel copyWith({
    String? locationName,
    String? address,
    String? description,
    List<String>? imageList,
    String? videoRef,
    num? ratingCount,
    num? point,
    double? lat,
    double? lng,
  }) {
    return LocationModel(
      locationName: locationName ?? this.locationName,
      address: address ?? this.address,
      description: description ?? this.description,
      imageList: imageList ?? this.imageList,
      videoRef: videoRef ?? this.videoRef,
      ratingCount: ratingCount ?? this.ratingCount,
      point: point ?? this.point,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationName': locationName,
      'address': address,
      'description': description,
      'imageList': imageList,
      'videoRef': videoRef,
      'ratingCount': ratingCount,
      'point': point,
      'lat': lat,
      'lng': lng,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      locationName: map['locationName'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      imageList: List<String>.from(map['imageList']),
      videoRef: map['videoRef'] ?? '',
      ratingCount: map['ratingCount'] ?? 0,
      point: map['point'] ?? 0,
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) => LocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationModel(locationName: $locationName, address: $address, description: $description, imageList: $imageList, videoRef: $videoRef, ratingCount: $ratingCount, point: $point, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LocationModel &&
      other.locationName == locationName &&
      other.address == address &&
      other.description == description &&
      listEquals(other.imageList, imageList) &&
      other.videoRef == videoRef &&
      other.ratingCount == ratingCount &&
      other.point == point &&
      other.lat == lat &&
      other.lng == lng;
  }

  @override
  int get hashCode {
    return locationName.hashCode ^
      address.hashCode ^
      description.hashCode ^
      imageList.hashCode ^
      videoRef.hashCode ^
      ratingCount.hashCode ^
      point.hashCode ^
      lat.hashCode ^
      lng.hashCode;
  }
}
