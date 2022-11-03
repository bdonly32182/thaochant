import 'dart:convert';

class EventModel {
  String url;
  num usageTime;
  double lat;
  double lng;
  int sequence;
  int totalSelected;
  String eventName;
  EventModel({
    required this.url,
    required this.usageTime,
    required this.lat,
    required this.lng,
    required this.sequence,
    required this.totalSelected,
    required this.eventName,
  });
  

  EventModel copyWith({
    String? url,
    num? usageTime,
    double? lat,
    double? lng,
    int? sequence,
    int? totalSelected,
    String? eventName,
  }) {
    return EventModel(
      url: url ?? this.url,
      usageTime: usageTime ?? this.usageTime,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      sequence: sequence ?? this.sequence,
      totalSelected: totalSelected ?? this.totalSelected,
      eventName: eventName ?? this.eventName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'usageTime': usageTime,
      'lat': lat,
      'lng': lng,
      'sequence': sequence,
      'totalSelected': totalSelected,
      'eventName': eventName,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      url: map['url'] ?? '',
      usageTime: map['usageTime']?.toDouble() ?? 0,
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
      sequence: map['sequence']?.toInt() ?? 0,
      totalSelected: map['totalSelected']?.toInt() ?? 0,
      eventName: map['eventName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));
}
