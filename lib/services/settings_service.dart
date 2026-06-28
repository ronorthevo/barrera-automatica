import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _ipKey = "ip";
  static const _passwordKey = "key";

  Future<void> save(String ip, String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_ipKey, ip);
    await prefs.setString(_passwordKey, key);
  }

  Future<String> getIp() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_ipKey) ?? "192.168.0.20";
  }

  Future<String> getKey() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_passwordKey) ?? "123456";
  }
}