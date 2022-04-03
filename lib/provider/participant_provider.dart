import 'package:chanthaburi_app/models/resort/filter_resort.dart';
import 'package:flutter/foundation.dart';

class ParticipantProvider with ChangeNotifier {
  FilterResort _partipant = FilterResort(totalAdult: 0,totalRoom: 0,totalYouth: 0, checkIn: 0, checkOut: 0, resortId: '', selectRoom: 0);
  FilterResort get partipant => _partipant;

  setPartipant(int totalAdult,totalRoom,totalYouth, checkIn,checkOut) {
    _partipant = FilterResort(totalAdult: totalAdult,totalRoom: totalRoom,totalYouth: totalYouth, checkIn: checkIn, checkOut: checkOut, resortId: '', selectRoom: 0);
    notifyListeners();
  }
  reserveRoom(String resortId,int selectRoom){
    _partipant.resortId = resortId;
    _partipant.selectRoom = selectRoom;
    notifyListeners();
  }
}