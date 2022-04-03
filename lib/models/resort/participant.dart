import 'dart:convert';

class ParticipantModel {
  int totalRoom;
  int totalAdult;
  int totalYouth;
  ParticipantModel({
    required this.totalRoom,
    required this.totalAdult,
    required this.totalYouth,
  });

  ParticipantModel copyWith({
    int? totalRoom,
    int? totalAdult,
    int? totalYouth,
  }) {
    return ParticipantModel(
      totalRoom: totalRoom ?? this.totalRoom,
      totalAdult: totalAdult ?? this.totalAdult,
      totalYouth: totalYouth ?? this.totalYouth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRoom': totalRoom,
      'totalAdult': totalAdult,
      'totalYouth': totalYouth,
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      totalRoom: map['totalRoom']?.toInt() ?? 0,
      totalAdult: map['totalAdult']?.toInt() ?? 0,
      totalYouth: map['totalYouth']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParticipantModel.fromJson(String source) => ParticipantModel.fromMap(json.decode(source));

  @override
  String toString() => 'ParticipantModel(totalRoom: $totalRoom, totalAdult: $totalAdult, totalYouth: $totalYouth)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ParticipantModel &&
      other.totalRoom == totalRoom &&
      other.totalAdult == totalAdult &&
      other.totalYouth == totalYouth;
  }

  @override
  int get hashCode => totalRoom.hashCode ^ totalAdult.hashCode ^ totalYouth.hashCode;
}
