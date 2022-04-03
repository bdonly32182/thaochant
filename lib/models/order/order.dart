import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/models/sqlite/order_product.dart';

class OrderModel {
  String userId;
  ShippingModel addressInfo;
  num totalPrice;
  num prepaidPrice;
  String imagePayment;
  DateTime dateCreate;
  String businessId;
  String status;
  List<ProductCartModel> product;
  bool  reviewed;
  OrderModel({
    required this.userId,
    required this.addressInfo,
    required this.totalPrice,
    required this.prepaidPrice,
    required this.imagePayment,
    required this.dateCreate,
    required this.businessId,
    required this.status,
    required this.product,
    required this.reviewed,
  });
  

  OrderModel copyWith({
    String? userId,
    ShippingModel? addressInfo,
    num? totalPrice,
    num? prepaidPrice,
    String? imagePayment,
    DateTime? dateCreate,
    String? businessId,
    String? status,
    List<ProductCartModel>? product,
    bool? reviewed,
  }) {
    return OrderModel(
      userId: userId ?? this.userId,
      addressInfo: addressInfo ?? this.addressInfo,
      totalPrice: totalPrice ?? this.totalPrice,
      prepaidPrice: prepaidPrice ?? this.prepaidPrice,
      imagePayment: imagePayment ?? this.imagePayment,
      dateCreate: dateCreate ?? this.dateCreate,
      businessId: businessId ?? this.businessId,
      status: status ?? this.status,
      product: product ?? this.product,
      reviewed: reviewed ?? this.reviewed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'addressInfo': addressInfo.toMap(),
      'totalPrice': totalPrice,
      'prepaidPrice': prepaidPrice,
      'imagePayment': imagePayment,
      'dateCreate': dateCreate.millisecondsSinceEpoch,
      'businessId': businessId,
      'status': status,
      'product': product.map((x) => x.toMap()).toList(),
      'reviewed': reviewed,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] ?? '',
      addressInfo: ShippingModel.fromMap(map['addressInfo']),
      totalPrice: map['totalPrice'] ?? 0,
      prepaidPrice: map['prepaidPrice'] ?? 0,
      imagePayment: map['imagePayment'] ?? '',
      dateCreate: DateTime.fromMillisecondsSinceEpoch(map['dateCreate']),
      businessId: map['businessId'] ?? '',
      status: map['status'] ?? '',
      product: List<ProductCartModel>.from(map['product']?.map((x) => ProductCartModel.fromMap(x))),
      reviewed: map['reviewed'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(userId: $userId, addressInfo: $addressInfo, totalPrice: $totalPrice, prepaidPrice: $prepaidPrice, imagePayment: $imagePayment, dateCreate: $dateCreate, businessId: $businessId, status: $status, product: $product, reviewed: $reviewed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderModel &&
      other.userId == userId &&
      other.addressInfo == addressInfo &&
      other.totalPrice == totalPrice &&
      other.prepaidPrice == prepaidPrice &&
      other.imagePayment == imagePayment &&
      other.dateCreate == dateCreate &&
      other.businessId == businessId &&
      other.status == status &&
      listEquals(other.product, product) &&
      other.reviewed == reviewed;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      addressInfo.hashCode ^
      totalPrice.hashCode ^
      prepaidPrice.hashCode ^
      imagePayment.hashCode ^
      dateCreate.hashCode ^
      businessId.hashCode ^
      status.hashCode ^
      product.hashCode ^
      reviewed.hashCode;
  }
}
