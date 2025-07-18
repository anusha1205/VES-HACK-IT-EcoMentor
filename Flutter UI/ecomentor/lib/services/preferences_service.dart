import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  static final PreferencesService _instance = PreferencesService._internal();
  static late final SharedPreferences _prefs;

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> getHasSeenOnboarding() async {
    return _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_keyHasSeenOnboarding, value);
  }
}
