import 'dart:convert';

import 'package:flutter/foundation.dart';

class BusinessModel {
  String businessName;
  String sellerId;
  String address;
  double latitude;
  double longitude;
  int statusOpen;
  num ratingCount;
  num point;
  List<dynamic> policyName;
  List<dynamic> policyDescription;
  String paymentNumber;
  String qrcodeRef;
  String phoneNumber;
  String link;
  String imageRef;
  double startPrice;
  BusinessModel({
    required this.businessName,
    required this.sellerId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.statusOpen,
    required this.ratingCount,
    required this.point,
    required this.policyName,
    required this.policyDescription,
    required this.paymentNumber,
    required this.qrcodeRef,
    required this.phoneNumber,
    required this.link,
    required this.imageRef,
    required this.startPrice,
  });
  

  BusinessModel copyWith({
    String? businessName,
    String? sellerId,
    String? address,
    double? latitude,
    double? longitude,
    int? statusOpen,
    num? ratingCount,
    num? point,
    List<dynamic>? policyName,
    List<dynamic>? policyDescription,
    String? paymentNumber,
    String? qrcodeRef,
    String? phoneNumber,
    String? link,
    String? imageRef,
    double? startPrice,
  }) {
    return BusinessModel(
      businessName: businessName ?? this.businessName,
      sellerId: sellerId ?? this.sellerId,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      statusOpen: statusOpen ?? this.statusOpen,
      ratingCount: ratingCount ?? this.ratingCount,
      point: point ?? this.point,
      policyName: policyName ?? this.policyName,
      policyDescription: policyDescription ?? this.policyDescription,
      paymentNumber: paymentNumber ?? this.paymentNumber,
      qrcodeRef: qrcodeRef ?? this.qrcodeRef,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      link: link ?? this.link,
      imageRef: imageRef ?? this.imageRef,
      startPrice: startPrice ?? this.startPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'sellerId': sellerId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'statusOpen': statusOpen,
      'ratingCount': ratingCount,
      'point': point,
      'policyName': policyName,
      'policyDescription': policyDescription,
      'paymentNumber': paymentNumber,
      'qrcodeRef': qrcodeRef,
      'phoneNumber': phoneNumber,
      'link': link,
      'imageRef': imageRef,
      'startPrice': startPrice,
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      businessName: map['businessName'] ?? '',
      sellerId: map['sellerId'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      statusOpen: map['statusOpen']?.toInt() ?? 0,
      ratingCount: map['ratingCount'] ?? 0,
      point: map['point'] ?? 0,
      policyName: List<dynamic>.from(map['policyName']),
      policyDescription: List<dynamic>.from(map['policyDescription']),
      paymentNumber: map['paymentNumber'] ?? '',
      qrcodeRef: map['qrcodeRef'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      link: map['link'] ?? '',
      imageRef: map['imageRef'] ?? '',
      startPrice: map['startPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusinessModel.fromJson(String source) => BusinessModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BusinessModel(businessName: $businessName, sellerId: $sellerId, address: $address, latitude: $latitude, longitude: $longitude, statusOpen: $statusOpen, ratingCount: $ratingCount, point: $point, policyName: $policyName, policyDescription: $policyDescription, paymentNumber: $paymentNumber, qrcodeRef: $qrcodeRef, phoneNumber: $phoneNumber, link: $link, imageRef: $imageRef, startPrice: $startPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BusinessModel &&
      other.businessName == businessName &&
      other.sellerId == sellerId &&
      other.address == address &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.statusOpen == statusOpen &&
      other.ratingCount == ratingCount &&
      other.point == point &&
      listEquals(other.policyName, policyName) &&
      listEquals(other.policyDescription, policyDescription) &&
      other.paymentNumber == paymentNumber &&
      other.qrcodeRef == qrcodeRef &&
      other.phoneNumber == phoneNumber &&
      other.link == link &&
      other.imageRef == imageRef &&
      other.startPrice == startPrice;
  }

  @override
  int get hashCode {
    return businessName.hashCode ^
      sellerId.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      statusOpen.hashCode ^
      ratingCount.hashCode ^
      point.hashCode ^
      policyName.hashCode ^
      policyDescription.hashCode ^
      paymentNumber.hashCode ^
      qrcodeRef.hashCode ^
      phoneNumber.hashCode ^
      link.hashCode ^
      imageRef.hashCode ^
      startPrice.hashCode;
  }
}
