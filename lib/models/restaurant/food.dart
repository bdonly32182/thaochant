import 'dart:convert';

import 'package:flutter/foundation.dart';


class FoodModel {
  String foodName;
  double price;
  String imageRef;
  String restaurantId;
  String categoryId;
  String description;
  int status;
  List<String> optionId;
  FoodModel({
    required this.foodName,
    required this.price,
    required this.imageRef,
    required this.restaurantId,
    required this.categoryId,
    required this.description,
    required this.status,
    required this.optionId,
  });
  


  FoodModel copyWith({
    String? foodName,
    double? price,
    String? imageRef,
    String? restaurantId,
    String? categoryId,
    String? description,
    int? status,
    List<String>? optionId,
  }) {
    return FoodModel(
      foodName: foodName ?? this.foodName,
      price: price ?? this.price,
      imageRef: imageRef ?? this.imageRef,
      restaurantId: restaurantId ?? this.restaurantId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      status: status ?? this.status,
      optionId: optionId ?? this.optionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'price': price,
      'imageRef': imageRef,
      'restaurantId': restaurantId,
      'categoryId': categoryId,
      'description': description,
      'status': status,
      'optionId': optionId,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      foodName: map['foodName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageRef: map['imageRef'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      description: map['description'] ?? '',
      status: map['status']?.toInt() ?? 0,
      optionId: List<String>.from(map['optionId']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodModel(foodName: $foodName, price: $price, imageRef: $imageRef, restaurantId: $restaurantId, categoryId: $categoryId, description: $description, status: $status, optionId: $optionId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FoodModel &&
      other.foodName == foodName &&
      other.price == price &&
      other.imageRef == imageRef &&
      other.restaurantId == restaurantId &&
      other.categoryId == categoryId &&
      other.description == description &&
      other.status == status &&
      listEquals(other.optionId, optionId);
  }

  @override
  int get hashCode {
    return foodName.hashCode ^
      price.hashCode ^
      imageRef.hashCode ^
      restaurantId.hashCode ^
      categoryId.hashCode ^
      description.hashCode ^
      status.hashCode ^
      optionId.hashCode;
  }
}
