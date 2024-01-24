import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider extends ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLangauge(Locale type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _appLocale = type;

    if (type == const Locale('ne')) {
      await preferences.setString("language_code", 'ne');
    } else {
      await preferences.setString("language_code", "en");
    }

    notifyListeners();
  }
}
