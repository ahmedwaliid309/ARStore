import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// إعدادات التطبيق. بتتحفظ على الجهاز. المسؤول: وليد. إيمان بتربط شاشة Settings بيه.
class SettingsProvider extends ChangeNotifier {
  bool darkMode = false;
  String language = 'en';
  bool notifications = true;
  bool autoDetectFloor = true;
  bool saveArShots = true;
  String units = 'Centimetres';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    darkMode = p.getBool('darkMode') ?? false;
    language = p.getString('language') ?? 'en';
    notifications = p.getBool('notifications') ?? true;
    autoDetectFloor = p.getBool('autoDetectFloor') ?? true;
    saveArShots = p.getBool('saveArShots') ?? true;
    units = p.getString('units') ?? 'Centimetres';
    notifyListeners();
  }

  Future<void> setDarkMode(bool v) => _setBool('darkMode', v, () => darkMode = v);
  Future<void> setNotifications(bool v) =>
      _setBool('notifications', v, () => notifications = v);
  Future<void> setAutoDetectFloor(bool v) =>
      _setBool('autoDetectFloor', v, () => autoDetectFloor = v);
  Future<void> setSaveArShots(bool v) =>
      _setBool('saveArShots', v, () => saveArShots = v);

  Future<void> setLanguage(String v) async {
    language = v;
    notifyListeners();
    (await SharedPreferences.getInstance()).setString('language', v);
  }

  Future<void> setUnits(String v) async {
    units = v;
    notifyListeners();
    (await SharedPreferences.getInstance()).setString('units', v);
  }

  Future<void> _setBool(String key, bool v, VoidCallback apply) async {
    apply();
    notifyListeners();
    (await SharedPreferences.getInstance()).setBool(key, v);
  }
}