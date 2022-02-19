import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  String? role;
  String? profileRef;

  UserModel({
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.role,
    this.profileRef,
  });

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          fullName: json['fullName']! as String,
          email: json['email']! as String,
          phoneNumber: json["phoneNumber"]! as String,
          role: json["role"]! as String,
          profileRef: json["profileRef"]! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'profileRef': profileRef,
    };
  }
  // Map<String, dynamic> toMap() {
  //   return {
  //     'fullName': fullName,
  //     'email': email,
  //     'phoneNumber': phoneNumber,
  //     'password': password,
  //     'role': role,
  //     'profileRef': profileRef,
  //   };
  // }

  // factory UserModel.fromMap(UserModel map) {
  //   return UserModel(
  //     fullName: map.fullName,
  //     email: map.get("email"),
  //     phoneNumber: map.get("phoneNumber"),
  //     // password: map['password'],
  //     role: map.get('role'),
  //     profileRef: map.get('profileRef'),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(Object source) =>
  //     UserModel.fromMap(source);
}
