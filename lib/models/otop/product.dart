import 'dart:convert';

class ProductOtopModel {
  String productName;
  double price;
  String imageRef;
  String otopId;
  String categoryId;
  String description;
  int status;
  double weight;
  double width;
  double height;
  double long;
  ProductOtopModel({
    required this.productName,
    required this.price,
    required this.imageRef,
    required this.otopId,
    required this.categoryId,
    required this.description,
    required this.status,
    required this.weight,
    required this.width,
    required this.height,
    required this.long,
  });



  ProductOtopModel copyWith({
    String? productName,
    double? price,
    String? imageRef,
    String? otopId,
    String? categoryId,
    String? description,
    int? status,
    double? weight,
    double? width,
    double? height,
    double? long,
  }) {
    return ProductOtopModel(
      productName: productName ?? this.productName,
      price: price ?? this.price,
      imageRef: imageRef ?? this.imageRef,
      otopId: otopId ?? this.otopId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      width: width ?? this.width,
      height: height ?? this.height,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'imageRef': imageRef,
      'otopId': otopId,
      'categoryId': categoryId,
      'description': description,
      'status': status,
      'weight': weight,
      'width': width,
      'height': height,
      'long': long,
    };
  }

  factory ProductOtopModel.fromMap(Map<String, dynamic> map) {
    return ProductOtopModel(
      productName: map['productName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageRef: map['imageRef'] ?? '',
      otopId: map['otopId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      description: map['description'] ?? '',
      status: map['status']?.toInt() ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      width: map['width']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOtopModel.fromJson(String source) => ProductOtopModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductOtopModel(productName: $productName, price: $price, imageRef: $imageRef, otopId: $otopId, categoryId: $categoryId, description: $description, status: $status, weight: $weight, width: $width, height: $height, long: $long)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductOtopModel &&
      other.productName == productName &&
      other.price == price &&
      other.imageRef == imageRef &&
      other.otopId == otopId &&
      other.categoryId == categoryId &&
      other.description == description &&
      other.status == status &&
      other.weight == weight &&
      other.width == width &&
      other.height == height &&
      other.long == long;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
      price.hashCode ^
      imageRef.hashCode ^
      otopId.hashCode ^
      categoryId.hashCode ^
      description.hashCode ^
      status.hashCode ^
      weight.hashCode ^
      width.hashCode ^
      height.hashCode ^
      long.hashCode;
  }
}
