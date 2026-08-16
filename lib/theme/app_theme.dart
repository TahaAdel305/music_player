

import 'package:flutter/material.dart';
import 'package:music_player/theme/app_color.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.colorlight,
    colorScheme: ColorScheme.light(
      primary: AppColor.colordark,
      surface: AppColor.colorlight,
    ),
    iconTheme: IconThemeData(
      color: AppColor.colordark,

    ),
);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.colordark,
    colorScheme: ColorScheme.dark(
    primary: AppColor.colorlight,
    surface: AppColor.colordark,
    ),
    iconTheme: IconThemeData(
        color: AppColor.colorlight
    ),
  );

}