import 'package:filmster/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MyThemeKeys { LIGHT, DARK, DARKER, Loft }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blueGrey[400],
    textSelectionColor: Colors.black,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blueGrey[600],
    brightness: Brightness.light,
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.blueGrey[900],
    brightness: Brightness.light,
  );
  static final ThemeData Loft = ThemeData(
    primaryColor: Color(0xffffC488),
    brightness: Brightness.light,
  );

  static ThemeData getThemeFromKey(BuildContext context, MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:{
        Provider.of<ThemeProvider>(context,listen: false).changeColor(
          fontColor:Colors.black,
          backgroundColor:Colors.white,
          mainColor:Colors.orange[200],
          acidColor:Colors.deepOrange[200],
          secondaryColor:Colors.black12,
          headerColor: Colors.blueGrey[800],

        );
          return lightTheme;
      }
      case MyThemeKeys.DARK:
        {
          Provider.of<ThemeProvider>(context,listen: false).changeColor(
            fontColor:Colors.white,
            backgroundColor: Colors.blueGrey[400],
            mainColor:Colors.orange[400],
            acidColor:Colors.deepOrange[400],
            secondaryColor:Colors.blueGrey[300],
            headerColor: Color.fromRGBO(241, 222, 170, 1.0)
          );
          return darkTheme;
        }
      case MyThemeKeys.DARKER:
        {
          Provider.of<ThemeProvider>(context,listen: false).changeColor(
            fontColor:Colors.white,
            backgroundColor:Colors.blueGrey[900],
            mainColor:Colors.orange[800],
            acidColor:Colors.deepOrange[800],
            secondaryColor:Colors.blueGrey[800],
            headerColor: Color.fromRGBO(241, 222, 170, 1.0)
          );
          return darkerTheme;
        }
      case MyThemeKeys.Loft :{
        Provider.of<ThemeProvider>(context,listen: false).changeColor(
          fontColor:Colors.black,
          backgroundColor: Color(0xffffdab9),
          mainColor:Colors.orange[800],
          acidColor:Colors.white,
          secondaryColor: Color(0xffffC488),
          headerColor: Colors.blueGrey[800],
        );
        return Loft;
      }
      default:
        return lightTheme;
    }
  }



}