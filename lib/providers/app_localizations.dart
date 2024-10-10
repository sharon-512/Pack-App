import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code DRY
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  late Map<String, dynamic> _localizedStrings;

  // Load the language JSON file from the "lang" folder
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/language/${locale.languageCode}.json');
    _localizedStrings = json.decode(jsonString);
    return true;
  }

  // Get a localized string by key
  String translate(String key) {
    return _getValueFromKey(key, _localizedStrings) ?? key;
  }

  // Retrieve nested keys (e.g., "home.title")
  dynamic _getValueFromKey(String key, Map<String, dynamic> map) {
    List<String> keys = key.split('.');
    dynamic value = map;
    for (String k in keys) {
      if (value[k] != null) {
        value = value[k];
      } else {
        return null;
      }
    }
    return value;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Supported languages
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
