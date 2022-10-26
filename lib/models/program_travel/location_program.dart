import 'dart:io';

class LocationProgramModel {
  String locationName;
  String time; // เวลาในการท่องเที่ยว
  String description; //รายละเอียด
  List<String> images; // รูปภาพเกี่ยวกับสถานที่นี้
  double lat;
  double lng;
  List<File>? imagesFiles;
  String dayId;
  LocationProgramModel({
    required this.time,
    required this.description,
    required this.images,
    required this.lat,
    required this.lng,
    required this.dayId,
    this.imagesFiles,
    required this.locationName,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'description': description,
      'images': images,
      'lat': lat,
      'lng': lng,
      'dayId': dayId,
      'locationName': locationName,
    };
  }

  factory LocationProgramModel.fromMap(Map<String, dynamic> map) {
    return LocationProgramModel(
      time: map['time'] ?? '',
      description: map['description'] ?? '',
      images: List<String>.from(map['images']),
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
      dayId: map["dayId"] ?? '',
      locationName: map["locationName"] ?? '',
      imagesFiles: [],
    );
  }
}
