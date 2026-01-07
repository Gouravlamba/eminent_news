import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getObject(String key) {
    final str = _prefs?.getString(key);
    if (str != null) {
      return jsonDecode(str) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> remove(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.clear();
  }
}
