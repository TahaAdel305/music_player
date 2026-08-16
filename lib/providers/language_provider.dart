import 'package:flutter/material.dart';

class AppLanguageProvider extends ChangeNotifier {
  Locale appLanguage = const Locale('en');

  void changeLanguage(String newLanguage) {
    if (appLanguage.languageCode == newLanguage) {
      return;
    }

    appLanguage = Locale(newLanguage);

    notifyListeners();
  }
}