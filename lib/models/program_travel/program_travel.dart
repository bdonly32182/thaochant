
import 'package:chanthaburi_app/models/program_travel/location_program.dart';

class ProgramTravelModel {
  String programName;
  List<String> dayIdList; // จำนวนวัน
  String rateDescription; // รายละเอียดอัตตรารวมค่าบริการ
  String introducePrice; // แนะนำโปรแกรม + ราคาแพ็คเกจ
  double price;
  List<LocationProgramModel> location;
  String imageCover;
  ProgramTravelModel({
    required this.programName,
    required this.dayIdList,
    required this.rateDescription,
    required this.introducePrice,
    required this.price,
    required this.location,
    required this.imageCover,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'programName': programName,
      'dayIdList': dayIdList,
      'rateDescription': rateDescription,
      'introducePrice': introducePrice,
      'price': price,
      'location': location.map((x) => x.toMap()).toList(),
      'imageCover': imageCover,
    };
  }

  factory ProgramTravelModel.fromMap(Map<String, dynamic> map) {
    return ProgramTravelModel(
      programName: map['programName'] ?? '',
      dayIdList: List<String>.from(map['dayIdList']),
      rateDescription: map['rateDescription'] ?? '',
      introducePrice: map['introducePrice'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      location: List<LocationProgramModel>.from(map['location']?.map((x) => LocationProgramModel.fromMap(x))),
      imageCover: map['imageCover'] ?? '',
    );
  }

}
