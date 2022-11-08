import 'dart:convert';

class HistoryIntroduceTravelModel {
  num usageTime;
  List<String> introProdId;
  List<String> eventId;
  HistoryIntroduceTravelModel({
    required this.usageTime,
    required this.introProdId,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'usageTime': usageTime,
      'introProdId': introProdId,
      'eventId': eventId,
    };
  }

  factory HistoryIntroduceTravelModel.fromMap(Map<String, dynamic> map) {
    return HistoryIntroduceTravelModel(
      usageTime: map['usageTime'] ?? 0,
      introProdId: List<String>.from(map['introProdId']),
      eventId: List<String>.from(map['eventId']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryIntroduceTravelModel.fromJson(String source) =>
      HistoryIntroduceTravelModel.fromMap(json.decode(source));
}
