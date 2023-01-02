import 'package:flutter/material.dart';
import 'requestDataProvider.dart';

class LanguageProvider with ChangeNotifier {
  static Locale appLocale = const Locale('en');

  static bool get isEng {
    return appLocale == Locale('en');
  }

  void changeLanguage() {
    if (appLocale == const Locale("ar")) {
      appLocale = const Locale("en");
    } else {
      appLocale = const Locale("ar");
    }
    notifyListeners();
  }

  Locale getLang() {
    return appLocale;
  }
}
