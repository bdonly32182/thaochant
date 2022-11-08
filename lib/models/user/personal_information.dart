import 'dart:convert';

class PersonalInformationModel {
  String gender;
  String age;
  String avgSalary;
  String payForTravel;
  String memberForTravel;
  PersonalInformationModel({
    required this.gender,
    required this.age,
    required this.avgSalary,
    required this.payForTravel,
    required this.memberForTravel,
  });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'age': age,
      'avgSalary': avgSalary,
      'payForTravel': payForTravel,
      'memberForTravel': memberForTravel,
    };
  }

  factory PersonalInformationModel.fromMap(Map<String, dynamic> map) {
    return PersonalInformationModel(
      gender: map['gender'] ?? '',
      age: map['age'] ?? '',
      avgSalary: map['avgSalary'] ?? '',
      payForTravel: map['payForTravel'] ?? '',
      memberForTravel: map['memberForTravel'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalInformationModel.fromJson(String source) =>
      PersonalInformationModel.fromMap(json.decode(source));
}
