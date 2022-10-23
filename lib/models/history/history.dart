class HistoryBusinessModel {
  String userId;
  String businessId;
  DateTime timeIn;
  DateTime timeOut;
  int totalTime;
  String? typeBusiness;
  HistoryBusinessModel({
    required this.userId,
    required this.businessId,
    required this.timeIn,
    required this.timeOut,
    required this.totalTime,
    this.typeBusiness,
  });

  HistoryBusinessModel copyWith(
      {String? userId,
      String? businessId,
      DateTime? timeIn,
      DateTime? timeOut,
      int? totalTime,
      String? typeBusiness}) {
    return HistoryBusinessModel(
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      totalTime: totalTime ?? this.totalTime,
      typeBusiness: typeBusiness ?? this.typeBusiness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'businessId': businessId,
      'timeIn': timeIn.millisecondsSinceEpoch,
      'timeOut': timeOut.millisecondsSinceEpoch,
      'totalTime': totalTime,
    };
  }

  factory HistoryBusinessModel.fromMap(Map<String, dynamic> map) {
    return HistoryBusinessModel(
      userId: map['userId'] ?? '',
      businessId: map['businessId'] ?? '',
      timeIn: DateTime.fromMillisecondsSinceEpoch(map['timeIn']),
      timeOut: DateTime.fromMillisecondsSinceEpoch(map['timeOut']),
      totalTime: map['totalTime'] ?? 0,
    );
  }

  Map<String, dynamic> toMapSqlite() {
    return {
      'userId': userId,
      'businessId': businessId,
      'timeIn': timeIn.millisecondsSinceEpoch,
      'timeOut': timeOut.millisecondsSinceEpoch,
      'totalTime': totalTime,
      'typeBusiness': typeBusiness,
    };
  }

  factory HistoryBusinessModel.fromMapSqlite(Map<String, dynamic> map) {
    return HistoryBusinessModel(
      userId: map['userId'] ?? '',
      businessId: map['businessId'] ?? '',
      timeIn: DateTime.fromMillisecondsSinceEpoch(map['timeIn']),
      timeOut: DateTime.fromMillisecondsSinceEpoch(map['timeOut']),
      totalTime: map['totalTime'] ?? 0,
      typeBusiness: map['typeBusiness'] ?? '',
    );
  }
}
