import 'dart:convert';

import 'package:flutter/foundation.dart';

class RoomModel {
  String roomName;
  double price;
  String imageCover;
  List<String> listImageDetail;
  String resortId;
  String categoryId;
  String descriptionRoom;
  int totalRoom;
  double roomSize;
  int totalGuest;
  RoomModel({
    required this.roomName,
    required this.price,
    required this.imageCover,
    required this.listImageDetail,
    required this.resortId,
    required this.categoryId,
    required this.descriptionRoom,
    required this.totalRoom,
    required this.roomSize,
    required this.totalGuest,
  });
 

  RoomModel copyWith({
    String? roomName,
    double? price,
    String? imageCover,
    List<String>? listImageDetail,
    String? resortId,
    String? categoryId,
    String? descriptionRoom,
    int? totalRoom,
    double? roomSize,
    int? totalGuest,
  }) {
    return RoomModel(
      roomName: roomName ?? this.roomName,
      price: price ?? this.price,
      imageCover: imageCover ?? this.imageCover,
      listImageDetail: listImageDetail ?? this.listImageDetail,
      resortId: resortId ?? this.resortId,
      categoryId: categoryId ?? this.categoryId,
      descriptionRoom: descriptionRoom ?? this.descriptionRoom,
      totalRoom: totalRoom ?? this.totalRoom,
      roomSize: roomSize ?? this.roomSize,
      totalGuest: totalGuest ?? this.totalGuest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'price': price,
      'imageCover': imageCover,
      'listImageDetail': listImageDetail,
      'resortId': resortId,
      'categoryId': categoryId,
      'descriptionRoom': descriptionRoom,
      'totalRoom': totalRoom,
      'roomSize': roomSize,
      'totalGuest': totalGuest,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomName: map['roomName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageCover: map['imageCover'] ?? '',
      listImageDetail: List<String>.from(map['listImageDetail']),
      resortId: map['resortId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      descriptionRoom: map['descriptionRoom'] ?? '',
      totalRoom: map['totalRoom']?.toInt() ?? 0,
      roomSize: map['roomSize']?.toDouble() ?? 0.0,
      totalGuest: map['totalGuest']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RoomModel(roomName: $roomName, price: $price, imageCover: $imageCover, listImageDetail: $listImageDetail, resortId: $resortId, categoryId: $categoryId, descriptionRoom: $descriptionRoom, totalRoom: $totalRoom, roomSize: $roomSize, totalGuest: $totalGuest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RoomModel &&
      other.roomName == roomName &&
      other.price == price &&
      other.imageCover == imageCover &&
      listEquals(other.listImageDetail, listImageDetail) &&
      other.resortId == resortId &&
      other.categoryId == categoryId &&
      other.descriptionRoom == descriptionRoom &&
      other.totalRoom == totalRoom &&
      other.roomSize == roomSize &&
      other.totalGuest == totalGuest;
  }

  @override
  int get hashCode {
    return roomName.hashCode ^
      price.hashCode ^
      imageCover.hashCode ^
      listImageDetail.hashCode ^
      resortId.hashCode ^
      categoryId.hashCode ^
      descriptionRoom.hashCode ^
      totalRoom.hashCode ^
      roomSize.hashCode ^
      totalGuest.hashCode;
  }
}
