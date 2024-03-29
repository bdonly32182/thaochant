import 'dart:convert';

class PartnerModel {
  String fullName;
  String email;
  String phoneNumber;
  String password;
  String role;
  String profileRef;
  String verifyRef;
  double lat;
  double lng;
  String address;
  bool isAccept;
  String tokenDevice;
  String rangeAge;
  String gender;
  PartnerModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.profileRef,
    required this.verifyRef,
    required this.lat,
    required this.lng,
    required this.address,
    required this.isAccept,
    required this.tokenDevice,
    required this.rangeAge,
    required this.gender,
  });

  PartnerModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    String? role,
    String? profileRef,
    String? verifyRef,
    double? lat,
    double? lng,
    String? address,
    bool? isAccept,
    String? tokenDevice,
    String? rangeAge,
    String? gender,
  }) {
    return PartnerModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      role: role ?? this.role,
      profileRef: profileRef ?? this.profileRef,
      verifyRef: verifyRef ?? this.verifyRef,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      isAccept: isAccept ?? this.isAccept,
      tokenDevice: tokenDevice ?? this.tokenDevice,
      rangeAge: rangeAge ?? this.rangeAge,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
      'profileRef': profileRef,
      'verifyRef': verifyRef,
      'lat': lat,
      'lng': lng,
      'address': address,
      'isAccept': isAccept,
      'tokenDevice': tokenDevice,
      'rangeAge': rangeAge,
      'gender': gender,
    };
  }

  factory PartnerModel.fromMap(Map<String, dynamic> map) {
    return PartnerModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      profileRef: map['profileRef'] ?? '',
      verifyRef: map['verifyRef'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      isAccept: map['isAccept'] ?? false,
      tokenDevice: map['tokenDevice'] ?? '',
      rangeAge: map['rangeAge'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PartnerModel.fromJson(String source) =>
      PartnerModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PartnerModel(fullName: $fullName, email: $email, phoneNumber: $phoneNumber, password: $password, role: $role, profileRef: $profileRef, verifyRef: $verifyRef, lat: $lat, lng: $lng, address: $address, isAccept: $isAccept, tokenDevice: $tokenDevice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PartnerModel &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.role == role &&
        other.profileRef == profileRef &&
        other.verifyRef == verifyRef &&
        other.lat == lat &&
        other.lng == lng &&
        other.address == address &&
        other.isAccept == isAccept &&
        other.tokenDevice == tokenDevice;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        password.hashCode ^
        role.hashCode ^
        profileRef.hashCode ^
        verifyRef.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        address.hashCode ^
        isAccept.hashCode ^
        tokenDevice.hashCode;
  }
}
