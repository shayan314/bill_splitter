import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _currencyKey = 'currency';
  static const String _defaultTipKey = 'defaultTip';
  static const String _defaultPeopleKey = 'defaultPeople';

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? 'Rs.';
  }

  Future<void> setDefaultTip(double tip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_defaultTipKey, tip);
  }

  Future<double> getDefaultTip() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_defaultTipKey) ?? 15.0;
  }

  Future<void> setDefaultPeople(int people) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultPeopleKey, people);
  }

  Future<int> getDefaultPeople() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_defaultPeopleKey) ?? 2;
  }
}
