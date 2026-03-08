import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User Session
  static Future<void> saveUserId(String userId) async {
    await _prefs.setString('user_id', userId);
  }

  static String? getUserId() {
    return _prefs.getString('user_id');
  }

  static Future<void> clearSession() async {
    await _prefs.clear();
  }

  // Onboarding
  static Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool('onboarding_complete', value);
  }

  static bool isOnboardingComplete() {
    return _prefs.getBool('onboarding_complete') ?? false;
  }

  // Generic preferences helpers
  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }
}
