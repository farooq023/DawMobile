import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  static Locale appLocale = Locale('ar');

  void changeLanguage(Locale type) {
    if (appLocale == type) {
      return;
    }
    if (type == Locale("ar")) {
      appLocale = Locale("ar");
      // await prefs.setString('language_code', 'ar');
      // await prefs.setString('countryCode', '');
    }
    else {
      appLocale = Locale("en");
      // await prefs.setString('language_code', 'en');
      // await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }

  void changeLanguageTest() {
    if (appLocale == Locale("ar")) {
      appLocale = Locale("en");
    }
    else {
      appLocale = Locale("ar");
    }
    print('chngd');
    print(appLocale);
    notifyListeners();
  }
}
