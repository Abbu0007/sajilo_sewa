import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    final p = _prefs;
    if (p == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return p;
  }

  Future<bool> setString(String key, String value) => _p.setString(key, value);
  String? getString(String key) => _p.getString(key);

  Future<bool> setBool(String key, bool value) => _p.setBool(key, value);
  bool? getBool(String key) => _p.getBool(key);

  Future<bool> remove(String key) => _p.remove(key);
  Future<bool> clear() => _p.clear();
}
