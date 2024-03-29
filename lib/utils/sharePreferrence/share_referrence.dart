import 'package:shared_preferences/shared_preferences.dart';

class ShareRefferrence {
  static Future<SharedPreferences> referrences =
      SharedPreferences.getInstance();

  static Future<String?> getRole() async {
    final SharedPreferences _referrence = await referrences;
    String? role = _referrence.getString('role');
    return role;
  }

  static Future<String> getUserId() async {
    final SharedPreferences _referrence = await referrences;
    String userId = _referrence.getString('userId') ?? "";
    return userId;
  }

  static Future<int?> getTimeQuestion() async {
    final SharedPreferences _referrence = await referrences;
    int? nextTime = _referrence.getInt("timeQuestion");
    return nextTime;
  }

  static Future<void> setReferrence(String role, String userId) async {
    final SharedPreferences _referrence = await referrences;
    _referrence.setString("role", role);
    _referrence.setString("userId", userId);
  }

  static Future<void> setTimeQuestion(int dateTime) async {
    final SharedPreferences _referrence = await referrences;
    _referrence.setInt("timeQuestion", dateTime);
  }

  static Future<List<String>?> getTravelFilterCurrent() async {
    final SharedPreferences _referrence = await referrences;
    List<String>? travelFilterString =
        _referrence.getStringList("travelFilter");
    return travelFilterString;
  }

  static Future<void> setTravelFilterCurrent(List<String> locations) async {
    // locations is json decode to string
    final SharedPreferences _referrence = await referrences;
    _referrence.setStringList("travelFilter", locations);
  }

  static Future<void> delTravelFilterCurrent() async {
    final SharedPreferences _referrence = await referrences;
    _referrence.remove("travelFilter");
  }
}
