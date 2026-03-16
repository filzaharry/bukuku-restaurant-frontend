import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  static late SharedPreferences _prefs;

  static Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return StorageService();
  }

  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
