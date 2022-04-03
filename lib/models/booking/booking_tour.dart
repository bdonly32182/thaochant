import 'dart:convert';

import 'package:chanthaburi_app/models/shipping/shipping.dart';

class BookingTourModel {
  ShippingModel addressInfo;
  String userId;
  String tourId;
  String tourName;
  double totalPrice;
  int adult;
  int senior;
  int youth;
  String status;
  String imagePayment;
  DateTime checkIn;
  DateTime checkOut;
  DateTime dateCreate;
  bool reviewed;
  BookingTourModel({
    required this.addressInfo,
    required this.userId,
    required this.tourId,
    required this.tourName,
    required this.totalPrice,
    required this.adult,
    required this.senior,
    required this.youth,
    required this.status,
    required this.imagePayment,
    required this.checkIn,
    required this.checkOut,
    required this.dateCreate,
    required this.reviewed,
  });
  

  BookingTourModel copyWith({
    ShippingModel? addressInfo,
    String? userId,
    String? tourId,
    String? tourName,
    double? totalPrice,
    int? adult,
    int? senior,
    int? youth,
    String? status,
    String? imagePayment,
    DateTime? checkIn,
    DateTime? checkOut,
    DateTime? dateCreate,
    bool? reviewed,
  }) {
    return BookingTourModel(
      addressInfo: addressInfo ?? this.addressInfo,
      userId: userId ?? this.userId,
      tourId: tourId ?? this.tourId,
      tourName: tourName ?? this.tourName,
      totalPrice: totalPrice ?? this.totalPrice,
      adult: adult ?? this.adult,
      senior: senior ?? this.senior,
      youth: youth ?? this.youth,
      status: status ?? this.status,
      imagePayment: imagePayment ?? this.imagePayment,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      dateCreate: dateCreate ?? this.dateCreate,
      reviewed: reviewed ?? this.reviewed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addressInfo': addressInfo.toMap(),
      'userId': userId,
      'tourId': tourId,
      'tourName': tourName,
      'totalPrice': totalPrice,
      'adult': adult,
      'senior': senior,
      'youth': youth,
      'status': status,
      'imagePayment': imagePayment,
      'checkIn': checkIn.millisecondsSinceEpoch,
      'checkOut': checkOut.millisecondsSinceEpoch,
      'dateCreate': dateCreate.millisecondsSinceEpoch,
      'reviewed': reviewed,
    };
  }

  factory BookingTourModel.fromMap(Map<String, dynamic> map) {
    return BookingTourModel(
      addressInfo: ShippingModel.fromMap(map['addressInfo']),
      userId: map['userId'] ?? '',
      tourId: map['tourId'] ?? '',
      tourName: map['tourName'] ?? '',
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      adult: map['adult']?.toInt() ?? 0,
      senior: map['senior']?.toInt() ?? 0,
      youth: map['youth']?.toInt() ?? 0,
      status: map['status'] ?? '',
      imagePayment: map['imagePayment'] ?? '',
      checkIn: DateTime.fromMillisecondsSinceEpoch(map['checkIn']),
      checkOut: DateTime.fromMillisecondsSinceEpoch(map['checkOut']),
      dateCreate: DateTime.fromMillisecondsSinceEpoch(map['dateCreate']),
      reviewed: map['reviewed'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingTourModel.fromJson(String source) => BookingTourModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookingTourModel(addressInfo: $addressInfo, userId: $userId, tourId: $tourId, tourName: $tourName, totalPrice: $totalPrice, adult: $adult, senior: $senior, youth: $youth, status: $status, imagePayment: $imagePayment, checkIn: $checkIn, checkOut: $checkOut, dateCreate: $dateCreate, reviewed: $reviewed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BookingTourModel &&
      other.addressInfo == addressInfo &&
      other.userId == userId &&
      other.tourId == tourId &&
      other.tourName == tourName &&
      other.totalPrice == totalPrice &&
      other.adult == adult &&
      other.senior == senior &&
      other.youth == youth &&
      other.status == status &&
      other.imagePayment == imagePayment &&
      other.checkIn == checkIn &&
      other.checkOut == checkOut &&
      other.dateCreate == dateCreate &&
      other.reviewed == reviewed;
  }

  @override
  int get hashCode {
    return addressInfo.hashCode ^
      userId.hashCode ^
      tourId.hashCode ^
      tourName.hashCode ^
      totalPrice.hashCode ^
      adult.hashCode ^
      senior.hashCode ^
      youth.hashCode ^
      status.hashCode ^
      imagePayment.hashCode ^
      checkIn.hashCode ^
      checkOut.hashCode ^
      dateCreate.hashCode ^
      reviewed.hashCode;
  }
}
