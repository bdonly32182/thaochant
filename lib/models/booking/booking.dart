import 'dart:convert';

import 'package:chanthaburi_app/models/shipping/shipping.dart';

class BookingModel {
  String userId;
  ShippingModel addressInfo;
  num totalPrice;
  int totalRoom;
  num prepaidPrice;
  String imagePayment;
  DateTime dateCreate;
  String resortId;
  String status;
  String roomId;
  bool  reviewed;
  DateTime checkIn;
  DateTime checkOut;
  BookingModel({
    required this.userId,
    required this.addressInfo,
    required this.totalPrice,
    required this.totalRoom,
    required this.prepaidPrice,
    required this.imagePayment,
    required this.dateCreate,
    required this.resortId,
    required this.status,
    required this.roomId,
    required this.reviewed,
    required this.checkIn,
    required this.checkOut,
  });
  

  BookingModel copyWith({
    String? userId,
    ShippingModel? addressInfo,
    num? totalPrice,
    int? totalRoom,
    num? prepaidPrice,
    String? imagePayment,
    DateTime? dateCreate,
    String? resortId,
    String? status,
    String? roomId,
    bool? reviewed,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return BookingModel(
      userId: userId ?? this.userId,
      addressInfo: addressInfo ?? this.addressInfo,
      totalPrice: totalPrice ?? this.totalPrice,
      totalRoom: totalRoom ?? this.totalRoom,
      prepaidPrice: prepaidPrice ?? this.prepaidPrice,
      imagePayment: imagePayment ?? this.imagePayment,
      dateCreate: dateCreate ?? this.dateCreate,
      resortId: resortId ?? this.resortId,
      status: status ?? this.status,
      roomId: roomId ?? this.roomId,
      reviewed: reviewed ?? this.reviewed,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'addressInfo': addressInfo.toMap(),
      'totalPrice': totalPrice,
      'totalRoom': totalRoom,
      'prepaidPrice': prepaidPrice,
      'imagePayment': imagePayment,
      'dateCreate': dateCreate.millisecondsSinceEpoch,
      'resortId': resortId,
      'status': status,
      'roomId': roomId,
      'reviewed': reviewed,
      'checkIn': checkIn.millisecondsSinceEpoch,
      'checkOut': checkOut.millisecondsSinceEpoch,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      userId: map['userId'] ?? '',
      addressInfo: ShippingModel.fromMap(map['addressInfo']),
      totalPrice: map['totalPrice'] ?? 0,
      totalRoom: map['totalRoom']?.toInt() ?? 0,
      prepaidPrice: map['prepaidPrice'] ?? 0,
      imagePayment: map['imagePayment'] ?? '',
      dateCreate: DateTime.fromMillisecondsSinceEpoch(map['dateCreate']),
      resortId: map['resortId'] ?? '',
      status: map['status'] ?? '',
      roomId: map['roomId'] ?? '',
      reviewed: map['reviewed'] ?? false,
      checkIn: DateTime.fromMillisecondsSinceEpoch(map['checkIn']),
      checkOut: DateTime.fromMillisecondsSinceEpoch(map['checkOut']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(String source) => BookingModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookingModel(userId: $userId, addressInfo: $addressInfo, totalPrice: $totalPrice, totalRoom: $totalRoom, prepaidPrice: $prepaidPrice, imagePayment: $imagePayment, dateCreate: $dateCreate, resortId: $resortId, status: $status, roomId: $roomId, reviewed: $reviewed, checkIn: $checkIn, checkOut: $checkOut)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BookingModel &&
      other.userId == userId &&
      other.addressInfo == addressInfo &&
      other.totalPrice == totalPrice &&
      other.totalRoom == totalRoom &&
      other.prepaidPrice == prepaidPrice &&
      other.imagePayment == imagePayment &&
      other.dateCreate == dateCreate &&
      other.resortId == resortId &&
      other.status == status &&
      other.roomId == roomId &&
      other.reviewed == reviewed &&
      other.checkIn == checkIn &&
      other.checkOut == checkOut;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      addressInfo.hashCode ^
      totalPrice.hashCode ^
      totalRoom.hashCode ^
      prepaidPrice.hashCode ^
      imagePayment.hashCode ^
      dateCreate.hashCode ^
      resortId.hashCode ^
      status.hashCode ^
      roomId.hashCode ^
      reviewed.hashCode ^
      checkIn.hashCode ^
      checkOut.hashCode;
  }
}
