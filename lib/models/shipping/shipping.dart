import 'dart:convert';

class ShippingModel {
  String userId;
  String fullName;
  String address;
  String phoneNumber;
  double lat;
  double lng;
  ShippingModel({
    required this.userId,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    required this.lat,
    required this.lng,
  });
  

  ShippingModel copyWith({
    String? userId,
    String? fullName,
    String? address,
    String? phoneNumber,
    double? lat,
    double? lng,
  }) {
    return ShippingModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'address': address,
      'phoneNumber': phoneNumber,
      'lat': lat,
      'lng': lng,
    };
  }

  factory ShippingModel.fromMap(Map<String, dynamic> map) {
    return ShippingModel(
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingModel.fromJson(String source) => ShippingModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShippingModel(userId: $userId, fullName: $fullName, address: $address, phoneNumber: $phoneNumber, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ShippingModel &&
      other.userId == userId &&
      other.fullName == fullName &&
      other.address == address &&
      other.phoneNumber == phoneNumber &&
      other.lat == lat &&
      other.lng == lng;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      fullName.hashCode ^
      address.hashCode ^
      phoneNumber.hashCode ^
      lat.hashCode ^
      lng.hashCode;
  }
}
