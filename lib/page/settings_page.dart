import 'dart:ui';
import 'package:filmster/Enums/PagesEnum.dart';
import 'package:filmster/Widgets/UI/CustomeBottomNavigationBar.dart';
import 'package:filmster/Widgets/UI/LIbraryActionButton.dart';
import 'package:filmster/localization/languages/workKeys.dart';
import 'package:filmster/localization/localization.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'library.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  void initState() {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    return WillPopScope(
        onWillPop: () {
          mySettings.changePage(Pages.HOME_PAGE);
          Navigator.of(context).pop();
        } as Future<bool> Function()?,
    child:Scaffold(
      key: scaffoldState,
      backgroundColor: myColors.currentBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations().translate(context, WordKeys.settings)!,
          style: TextStyle(
            fontFamily: "AmaticSC",
            fontSize: 20,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: LibraryActionButton.build(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //drawer: DrawerMenu().build(context),
      body: _buildBody(context),
    ),);
  }

  Widget _buildBody(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildTitle(AppLocalizations()
                        .translate(context, WordKeys.changeYourTheme)!),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    _buildThemeButton(MyThemeKeys.LIGHT, "Light"),
                    _buildThemeButton(MyThemeKeys.DARK, "Dark"),
                    _buildThemeButton(MyThemeKeys.DARKER, "Darker"),
                    _buildThemeButton(MyThemeKeys.Loft, "Loft"),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitle(AppLocalizations()
                      .translate(context, WordKeys.changeYourLanguage)!),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  _buildLanguageButton("us", "English"),
                  _buildLanguageButton("ru", "Russian"),
                  _buildLanguageButton("pt", "Portugalish"),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ]),
        ]
        ),
        Column(
          children: [
            Center(child:Padding(
              padding: const EdgeInsets.symmetric(vertical:24.0, ),
              child: Text("This product uses the TMDb API \nbut is not endorsed or certified by TMDb.",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "AmaticSC", fontSize: 20, color: Provider.of<ThemeProvider>(context).currentFontColor),),
            )),
            Image.asset("assets/image/tmdbLogo.png",
              width: MediaQuery.of(context).size.width-24,
            ),
            SizedBox(height: 48,),
          ],
        ),
      ],
    );
  }

  _buildLanguageButton(String languageCode, String languageName) {
    return RaisedButton(
      onPressed: () async {
        setState(() {
          Provider.of<SettingsProvider>(context, listen: false)
              .changeLanguage(languageCode);
          Prefs().setStringPrefs('languageCode', languageCode);
        });
        await Provider.of<SettingsProvider>(context, listen: false).loadMovieListGenres(scaffoldState);
        await Provider.of<SettingsProvider>(context, listen: false).loadTVListGenres(scaffoldState);
      },
      child: Text(
        languageName,
        style: TextStyle(fontFamily: "AmaticSC", fontSize: 20),
      ),
    );
  }

  _buildThemeButton(MyThemeKeys themeKey, String themeKeyName) {
    return RaisedButton(
      onPressed: () {
        Provider.of<ThemeProvider>(context, listen: false)
            .changeTheme(context, themeKey);
        Prefs().setStringPrefs('themeCode', themeKeyName);
      },
      child: Text(
        themeKeyName,
        style: TextStyle(fontFamily: "AmaticSC", fontSize: 20),
      ),
    );
  }

  _buildTitle(String titleText) {
    return Text(
      titleText,
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 26,
        color:
            Provider.of<ThemeProvider>(context, listen: false).currentFontColor,
      ),
    );
  }
}