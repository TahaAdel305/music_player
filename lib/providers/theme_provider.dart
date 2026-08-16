import 'package:flutter/material.dart';
class ThemeProvider extends ChangeNotifier{
  //ThemeMode themeMode = ThemeMode.light;
  ThemeMode appTheme = ThemeMode.light;
  void changeTheme(ThemeMode newTheme){
    if(appTheme==newTheme){
      return;
    }appTheme=newTheme;
    notifyListeners();
  }

}