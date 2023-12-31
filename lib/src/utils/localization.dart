import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A class for application-specific localizations.
///
/// This class manages the loading and translation of localized strings based on
/// the application's current locale.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Retrieves the current instance of the AppLocalizations class.
  ///
  /// [context] provides the BuildContext from which the localizations are to be accessed.
  ///
  /// Returns an instance of AppLocalizations or null if not found.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // A map to hold the localized strings.
  Map<String, String> _localizedStrings = {};

  /// Loads the localized strings from JSON files.
  ///
  /// Reads the locale-specific JSON file and loads the translated strings into a map.
  ///
  /// Returns true once the loading is complete.
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// Translates a given key to its localized string.
  ///
  /// [key] is the key for which the translation is required.
  ///
  /// Returns the translated string, or the key itself if no translation is found.
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // A delegate for the AppLocalizations class.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

/// A delegate class for the AppLocalizations class.
///
/// This delegate is responsible for instantiating the AppLocalizations
/// class and loading the appropriate localizations.
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Define the supported languages here.
    return ['en', 'de', 'hr', 'hu'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
