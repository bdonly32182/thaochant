class TimeTurnOnOfModel {
  String day;
  String timeOn;
  String timeOf;
  TimeTurnOnOfModel({
    required this.day,
    required this.timeOn,
    required this.timeOf,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'timeOn': timeOn,
      'timeOf': timeOf,
    };
  }

  factory TimeTurnOnOfModel.fromMap(Map<String, dynamic> map) {
    return TimeTurnOnOfModel(
      day: map['day'] ?? '',
      timeOn: map['timeOn'] ?? '',
      timeOf: map['timeOf'] ?? '',
    );
  }
}
