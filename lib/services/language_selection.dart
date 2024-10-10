import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleNotifier() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selected_language') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
