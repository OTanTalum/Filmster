import 'package:filmster/setting/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  MyThemeKeys currentThemeKeys = MyThemeKeys.LIGHT;

  ThemeData? currentTheme = MyThemes.lightTheme;

  Color? currentFontColor = Colors.black;
  Color? currentBackgroundColor = Colors.white;
  Color? currentMainColor = Colors.orange[200];
  Color? currentAcidColor = Colors.deepOrange[200];
  Color? currentSecondaryColor = Colors.black12;
  Color? currentHeaderColor = Colors.amberAccent;

  changeTheme(BuildContext context, MyThemeKeys key) {
    currentThemeKeys = key;
    currentTheme = MyThemes.getThemeFromKey( context, currentThemeKeys);
    notifyListeners();
  }

  changeColor( {
    Color? fontColor,
    Color? backgroundColor,
    Color? mainColor,
    Color? acidColor,
    Color? secondaryColor,
    Color? headerColor,
  }) {
    currentFontColor = fontColor;
    currentBackgroundColor = backgroundColor;
    currentMainColor = mainColor;
    currentAcidColor = acidColor;
    currentSecondaryColor = secondaryColor;
    currentHeaderColor = headerColor;
    notifyListeners();
  }

}
