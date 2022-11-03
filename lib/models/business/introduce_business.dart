import 'dart:convert';

class IntroduceBusinessModel {
  String name;
  int sequence;
  double lat;
  double lng;
  String businessId;
  int totalSelected;
  String typeBusiness;
  IntroduceBusinessModel({
    required this.name,
    required this.sequence,
    required this.lat,
    required this.lng,
    required this.businessId,
    required this.totalSelected,
    required this.typeBusiness,
  });

  IntroduceBusinessModel copyWith({
    String? name,
    int? sequence,
    double? lat,
    double? lng,
    String? businessId,
    int? totalSelected,
    String? typeBusiness,
  }) {
    return IntroduceBusinessModel(
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

  factory IntroduceBusinessModel.fromMap(Map<String, dynamic> map) {
    return IntroduceBusinessModel(
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

  factory IntroduceBusinessModel.fromJson(String source) => IntroduceBusinessModel.fromMap(json.decode(source));
}
