import 'package:flutter/material.dart';

/// Provider for managing localization settings in the app.
///
/// This class manages the app's current locale and provides a mechanism to change
/// the locale dynamically. It notifies listeners when the locale changes, allowing
/// widgets to rebuild with the new locale settings.
class LocaleProvider with ChangeNotifier {
  // Default locale set to English.
  Locale _currentLocale = const Locale('en');

  // Getter to expose the current locale.
  Locale get currentLocale => _currentLocale;

  /// Sets the app's locale to the provided locale if it's supported.
  ///
  /// The function checks if the provided locale's language code is among the supported
  /// languages ['en', 'de', 'hu', 'hr']. If it's not supported, the function does
  /// nothing. Otherwise, it updates the current locale and notifies listeners.
  ///
  /// [locale] - The new locale to be set for the app.
  void setLocale(Locale locale) {
    // Check if the provided locale's language code is supported.
    if (!['en', 'de', 'hu', 'hr'].contains(locale.languageCode)) {
      return; // Do nothing if the language code is not supported
    }
    // Update the current locale and notify listeners.
    _currentLocale = locale;
    notifyListeners();
  }
}
