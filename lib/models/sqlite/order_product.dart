import 'dart:convert';

// product === product on otop and food
class ProductCartModel {
  int? id;
  num? sumTotalPrice;
  String productId;
  String productName;
  String businessId;
  int amount;
  num totalPrice;
  num price;
  String businessName;
  String userId;
  String imageURL;
  String addtionMessage;
  ProductCartModel({
    this.id,
    this.sumTotalPrice,
    required this.productId,
    required this.productName,
    required this.businessId,
    required this.amount,
    required this.totalPrice,
    required this.price,
    required this.businessName,
    required this.userId,
    required this.imageURL,
    required this.addtionMessage,
  });
  

  ProductCartModel copyWith({
    int? id,
    num? sumTotalPrice,
    String? productId,
    String? productName,
    String? businessId,
    int? amount,
    num? totalPrice,
    num? price,
    String? businessName,
    String? userId,
    String? imageURL,
    String? addtionMessage,
  }) {
    return ProductCartModel(
      id: id ?? this.id,
      sumTotalPrice: sumTotalPrice ?? this.sumTotalPrice,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      businessId: businessId ?? this.businessId,
      amount: amount ?? this.amount,
      totalPrice: totalPrice ?? this.totalPrice,
      price: price ?? this.price,
      businessName: businessName ?? this.businessName,
      userId: userId ?? this.userId,
      imageURL: imageURL ?? this.imageURL,
      addtionMessage: addtionMessage ?? this.addtionMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'businessId': businessId,
      'amount': amount,
      'totalPrice': totalPrice,
      'price': price,
      'businessName': businessName,
      'userId': userId,
      'imageURL': imageURL,
      'addtionMessage': addtionMessage,
    };
  }

  factory ProductCartModel.fromMap(Map<String, dynamic> map) {
    return ProductCartModel(
      id: map['id']?.toInt(),
      sumTotalPrice: map['sumTotalPrice']?? 0,
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      businessId: map['businessId'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
      totalPrice: map['totalPrice'] ?? 0,
      price: map['price'] ?? 0,
      businessName: map['businessName'] ?? '',
      userId: map['userId'] ?? '',
      imageURL: map['imageURL'] ?? '',
      addtionMessage: map['addtionMessage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCartModel.fromJson(String source) => ProductCartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductCartModel(id: $id, sumTotalPrice: $sumTotalPrice, productId: $productId, productName: $productName, businessId: $businessId, amount: $amount, totalPrice: $totalPrice, price: $price, businessName: $businessName, userId: $userId, imageURL: $imageURL, addtionMessage: $addtionMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductCartModel &&
      other.id == id &&
      other.sumTotalPrice == sumTotalPrice &&
      other.productId == productId &&
      other.productName == productName &&
      other.businessId == businessId &&
      other.amount == amount &&
      other.totalPrice == totalPrice &&
      other.price == price &&
      other.businessName == businessName &&
      other.userId == userId &&
      other.imageURL == imageURL &&
      other.addtionMessage == addtionMessage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      sumTotalPrice.hashCode ^
      productId.hashCode ^
      productName.hashCode ^
      businessId.hashCode ^
      amount.hashCode ^
      totalPrice.hashCode ^
      price.hashCode ^
      businessName.hashCode ^
      userId.hashCode ^
      imageURL.hashCode ^
      addtionMessage.hashCode;
  }
}
