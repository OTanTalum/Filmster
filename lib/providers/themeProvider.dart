import 'package:filmster/setting/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  MyThemeKeys currentThemeKeys = MyThemeKeys.LIGHT;

  ThemeData currentTheme = MyThemes.lightTheme;

  Color currentFontColor = Colors.black;
  Color currentBackgroundColor = Colors.white70;
  Color currentMainColor = Colors.blueGrey[600];
  Color currentAcidColor = Colors.lime;
  Color currentSecondaryColor = Colors.blueGrey[900];

  changeTheme(BuildContext context, MyThemeKeys key) {
    currentThemeKeys = key;
    currentTheme = MyThemes.getThemeFromKey( context, currentThemeKeys);
    notifyListeners();
  }

  changeColor( {
    Color fontColor,
    Color backgroundColor,
    Color mainColor,
    Color acidColor,
    Color secondaryColor,
  }) {
    currentFontColor = fontColor;
    currentBackgroundColor = backgroundColor;
    currentMainColor = mainColor;
    currentAcidColor = acidColor;
    currentSecondaryColor = secondaryColor;
    notifyListeners();
  }

}
