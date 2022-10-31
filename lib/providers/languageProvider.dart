import 'package:flutter/material.dart';
import './ipProvider.dart';

class LanguageProvider with ChangeNotifier {
  static Locale appLocale = const Locale('en');

  // void getLocale(){
  //   return this.appLocale;
  // }

  bool get isEng {
    return appLocale == Locale('en');
  }

  void changeLanguage() {
    if (appLocale == const Locale("ar")) {
      appLocale = const Locale("en");
    }
    else {
      appLocale = const Locale("ar");
    }
    notifyListeners();
  }
}
