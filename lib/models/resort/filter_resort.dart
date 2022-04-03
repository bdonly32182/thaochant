import 'dart:convert';

class FilterResort {
  int totalRoom;
  int totalAdult;
  int totalYouth;
  int selectRoom;
  String resortId;
  int checkIn;
  int  checkOut;
  FilterResort({
    required this.totalRoom,
    required this.totalAdult,
    required this.totalYouth,
    required this.selectRoom,
    required this.resortId,
    required this.checkIn,
    required this.checkOut,
  });
  

  FilterResort copyWith({
    int? totalRoom,
    int? totalAdult,
    int? totalYouth,
    int? selectRoom,
    String? resortId,
    int? checkIn,
    int? checkOut,
  }) {
    return FilterResort(
      totalRoom: totalRoom ?? this.totalRoom,
      totalAdult: totalAdult ?? this.totalAdult,
      totalYouth: totalYouth ?? this.totalYouth,
      selectRoom: selectRoom ?? this.selectRoom,
      resortId: resortId ?? this.resortId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRoom': totalRoom,
      'totalAdult': totalAdult,
      'totalYouth': totalYouth,
      'selectRoom': selectRoom,
      'resortId': resortId,
      'checkIn': checkIn,
      'checkOut': checkOut,
    };
  }

  factory FilterResort.fromMap(Map<String, dynamic> map) {
    return FilterResort(
      totalRoom: map['totalRoom']?.toInt() ?? 0,
      totalAdult: map['totalAdult']?.toInt() ?? 0,
      totalYouth: map['totalYouth']?.toInt() ?? 0,
      selectRoom: map['selectRoom']?.toInt() ?? 0,
      resortId: map['resortId'] ?? '',
      checkIn: map['checkIn']?.toInt() ?? 0,
      checkOut: map['checkOut']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterResort.fromJson(String source) => FilterResort.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FilterResort(totalRoom: $totalRoom, totalAdult: $totalAdult, totalYouth: $totalYouth, selectRoom: $selectRoom, resortId: $resortId, checkIn: $checkIn, checkOut: $checkOut)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FilterResort &&
      other.totalRoom == totalRoom &&
      other.totalAdult == totalAdult &&
      other.totalYouth == totalYouth &&
      other.selectRoom == selectRoom &&
      other.resortId == resortId &&
      other.checkIn == checkIn &&
      other.checkOut == checkOut;
  }

  @override
  int get hashCode {
    return totalRoom.hashCode ^
      totalAdult.hashCode ^
      totalYouth.hashCode ^
      selectRoom.hashCode ^
      resortId.hashCode ^
      checkIn.hashCode ^
      checkOut.hashCode;
  }
}
