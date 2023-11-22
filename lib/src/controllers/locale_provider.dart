import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en'); // Default to English

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    if (!['en', 'de', 'hu', 'hr'].contains(locale.languageCode)) {
      return; // Do nothing if the language code is not supported
    }
    _currentLocale = locale;
    notifyListeners();
  }
}
