import 'dart:convert';

class IntroduceProductModel {
  String name;
  int sequence;
  double lat;
  double lng;
  String businessId;
  int totalSelected;
  String typeBusiness;
  IntroduceProductModel({
    required this.name,
    required this.sequence,
    required this.lat,
    required this.lng,
    required this.businessId,
    required this.totalSelected,
    required this.typeBusiness,
  });

  IntroduceProductModel copyWith({
    String? name,
    int? sequence,
    double? lat,
    double? lng,
    String? businessId,
    int? totalSelected,
    String? typeBusiness,
  }) {
    return IntroduceProductModel(
      name: name ?? this.name,
      sequence: sequence ?? this.sequence,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      businessId: businessId ?? this.businessId,
      totalSelected: totalSelected ?? this.totalSelected,
      typeBusiness: typeBusiness ?? this.typeBusiness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sequence': sequence,
      'lat': lat,
      'lng': lng,
      'businessId': businessId,
      'totalSelected': totalSelected,
      'typeBusiness': typeBusiness,
    };
  }

  factory IntroduceProductModel.fromMap(Map<String, dynamic> map) {
    return IntroduceProductModel(
      name: map['name'] ?? '',
      sequence: map['sequence']?.toInt() ?? 0,
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
      businessId: map['businessId'] ?? '',
      totalSelected: map['totalSelected']?.toInt() ?? 0,
      typeBusiness: map['typeBusiness'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IntroduceProductModel.fromJson(String source) => IntroduceProductModel.fromMap(json.decode(source));
}
