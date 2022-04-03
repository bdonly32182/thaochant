import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:chanthaburi_app/models/packagetour/id_name.dart';

class PackageTourModel {
  String packageName;
  double priceAdult;
  double priceYouth;
  double priceOlder;
  String description;
  List<IdAndName> guides;
  List<IdAndName> locations;
  List<IdAndName> resorts;
  String imageRef;
  String pdfRef;
  double point;
  double ratingCount;
  int status;
  String promptPay;
  String ownerPromptPay;
  PackageTourModel({
    required this.packageName,
    required this.priceAdult,
    required this.priceYouth,
    required this.priceOlder,
    required this.description,
    required this.guides,
    required this.locations,
    required this.resorts,
    required this.imageRef,
    required this.pdfRef,
    required this.point,
    required this.ratingCount,
    required this.status,
    required this.promptPay,
    required this.ownerPromptPay,
  });
  

  PackageTourModel copyWith({
    String? packageName,
    double? priceAdult,
    double? priceYouth,
    double? priceOlder,
    String? description,
    List<IdAndName>? guides,
    List<IdAndName>? locations,
    List<IdAndName>? resorts,
    String? imageRef,
    String? pdfRef,
    double? point,
    double? ratingCount,
    int? status,
    String? promptPay,
    String? ownerPromptPay,
  }) {
    return PackageTourModel(
      packageName: packageName ?? this.packageName,
      priceAdult: priceAdult ?? this.priceAdult,
      priceYouth: priceYouth ?? this.priceYouth,
      priceOlder: priceOlder ?? this.priceOlder,
      description: description ?? this.description,
      guides: guides ?? this.guides,
      locations: locations ?? this.locations,
      resorts: resorts ?? this.resorts,
      imageRef: imageRef ?? this.imageRef,
      pdfRef: pdfRef ?? this.pdfRef,
      point: point ?? this.point,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      promptPay: promptPay ?? this.promptPay,
      ownerPromptPay: ownerPromptPay ?? this.ownerPromptPay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'priceAdult': priceAdult,
      'priceYouth': priceYouth,
      'priceOlder': priceOlder,
      'description': description,
      'guides': guides.map((x) => x.toMap()).toList(),
      'locations': locations.map((x) => x.toMap()).toList(),
      'resorts': resorts.map((x) => x.toMap()).toList(),
      'imageRef': imageRef,
      'pdfRef': pdfRef,
      'point': point,
      'ratingCount': ratingCount,
      'status': status,
      'promptPay': promptPay,
      'ownerPromptPay': ownerPromptPay,
    };
  }

  factory PackageTourModel.fromMap(Map<String, dynamic> map) {
    return PackageTourModel(
      packageName: map['packageName'] ?? '',
      priceAdult: map['priceAdult']?.toDouble() ?? 0.0,
      priceYouth: map['priceYouth']?.toDouble() ?? 0.0,
      priceOlder: map['priceOlder']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      guides: List<IdAndName>.from(map['guides']?.map((x) => IdAndName.fromMap(x))),
      locations: List<IdAndName>.from(map['locations']?.map((x) => IdAndName.fromMap(x))),
      resorts: List<IdAndName>.from(map['resorts']?.map((x) => IdAndName.fromMap(x))),
      imageRef: map['imageRef'] ?? '',
      pdfRef: map['pdfRef'] ?? '',
      point: map['point']?.toDouble() ?? 0.0,
      ratingCount: map['ratingCount']?.toDouble() ?? 0.0,
      status: map['status']?.toInt() ?? 0,
      promptPay: map['promptPay'] ?? '',
      ownerPromptPay: map['ownerPromptPay'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageTourModel.fromJson(String source) => PackageTourModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PackageTourModel(packageName: $packageName, priceAdult: $priceAdult, priceYouth: $priceYouth, priceOlder: $priceOlder, description: $description, guides: $guides, locations: $locations, resorts: $resorts, imageRef: $imageRef, pdfRef: $pdfRef, point: $point, ratingCount: $ratingCount, status: $status, promptPay: $promptPay, ownerPromptPay: $ownerPromptPay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PackageTourModel &&
      other.packageName == packageName &&
      other.priceAdult == priceAdult &&
      other.priceYouth == priceYouth &&
      other.priceOlder == priceOlder &&
      other.description == description &&
      listEquals(other.guides, guides) &&
      listEquals(other.locations, locations) &&
      listEquals(other.resorts, resorts) &&
      other.imageRef == imageRef &&
      other.pdfRef == pdfRef &&
      other.point == point &&
      other.ratingCount == ratingCount &&
      other.status == status &&
      other.promptPay == promptPay &&
      other.ownerPromptPay == ownerPromptPay;
  }

  @override
  int get hashCode {
    return packageName.hashCode ^
      priceAdult.hashCode ^
      priceYouth.hashCode ^
      priceOlder.hashCode ^
      description.hashCode ^
      guides.hashCode ^
      locations.hashCode ^
      resorts.hashCode ^
      imageRef.hashCode ^
      pdfRef.hashCode ^
      point.hashCode ^
      ratingCount.hashCode ^
      status.hashCode ^
      promptPay.hashCode ^
      ownerPromptPay.hashCode;
  }
}
