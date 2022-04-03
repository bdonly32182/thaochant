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

  static Future<void> setReferrence(String role, String userId) async {
    final SharedPreferences _referrence = await referrences;
    _referrence.setString("role", role);
    _referrence.setString("userId", userId);
  }
}
