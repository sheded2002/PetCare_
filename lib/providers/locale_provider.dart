import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isArabic = false;

  LocaleProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;
  bool get isArabic => _isArabic;

  get isEnglish => null;

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final isArabic = prefs.getBool('isArabic') ?? false;
    _isArabic = isArabic;
    _locale = Locale(isArabic ? 'ar' : 'en');
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final prefs = await SharedPreferences.getInstance();
    _isArabic = !_isArabic;
    _locale = Locale(_isArabic ? 'ar' : 'en');
    await prefs.setBool('isArabic', _isArabic);
    notifyListeners();
  }
}
