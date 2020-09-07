
import 'dart:ui';

import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';

import 'package:filmster/widgets/drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Provider.of<ThemeProvider>(context).currentBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations().translate(context, WordKeys.settings),
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 20,
          ),
        ),
      ),
      drawer: DrawerMenu().build(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context){
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildTitle(AppLocalizations().translate(context, WordKeys.changeYourTheme)),
                    SizedBox(
                      height: 40,
                    width: MediaQuery.of(context).size.width*0.5,
                    ),
                    _buildThemeButton(MyThemeKeys.LIGHT, "Light"),
                    _buildThemeButton(MyThemeKeys.DARK, "Dark"),
                    _buildThemeButton(MyThemeKeys.DARKER, "Darker"),
                    _buildThemeButton(MyThemeKeys.Loft, "Loft"),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitle(AppLocalizations().translate(context, WordKeys.changeYourLanguage)),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width*0.5,
                  ),
                  _buildLanguageButton("us", "English"),
                  _buildLanguageButton("ru", "Russian"),
                  _buildLanguageButton("pt", "Spanish"),
                  SizedBox(height: 50,),
                ],
              ),
            ]),
      ],
    );
  }

  _buildLanguageButton (String languageCode, String languageName){
    return RaisedButton(
      onPressed: () async {
        setState(() {
          Provider.of<SettingsProvider>(context, listen: false)
              .changeLanguage(languageCode);
          Prefs().setStringPrefs('languageCode', languageCode);
        });
        await Provider.of<SettingsProvider>(context,
            listen: false)
            .getGanresSettings("movie");
        await Provider.of<SettingsProvider>(context,
            listen: false)
            .getGanresSettings("tv");
      },
      child: Text(
        languageName,
        style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 20
        ),
      ),
    );
  }

  _buildThemeButton(MyThemeKeys themeKey, String themeKeyName){
    return RaisedButton(
      onPressed: () {
        Provider.of<ThemeProvider>(context, listen: false)
            .changeTheme(context, themeKey);
        Prefs().setStringPrefs('themeCode', themeKeyName);
      },
      child: Text(
        themeKeyName,
        style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 20
        ),
      ),
    );
  }

  _buildTitle(String titleText){
    return Text(
      titleText,
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 26,
        color:
        Provider.of<ThemeProvider>(context, listen: false)
            .currentFontColor,
      ),
    );
  }

}
