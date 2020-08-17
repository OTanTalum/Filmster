//Widgets

import 'dart:io';

import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';
import 'package:filmster/widgets/drawer.dart';

//Flutter
import 'package:flutter/material.dart';
//Pages

import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filmster',
      home: MyHomePage(),
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      SettingsProvider.language=(
          await Prefs().getStringPrefs("languageCode")??'ru'
      );
      Provider.of<ThemeProvider>(context, listen: false)
          .changeTheme(context, await Prefs().getStringPrefs("themeKCode")??'Light');
      await Provider.of<SettingsProvider>(context, listen: false)    // Load List of genres with current language//
          .getGanresSettings();
    });
  }

  ///TODO 3. Attribution
  ///You shall use the TMDb logo to identify your use of the TMDb APIs.
  ///You shall place the following notice prominently on your application: "This product uses the TMDb API but is not endorsed or certified by TMDb."
  ///Any use of the TMDb logo in your application shall be less prominent than the logo or mark that primarily describes the application and your use of the TMDb logo shall not imply any endorsement by TMDb.


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
            .getGanresSettings();
      },
      child: Text(
        languageName,
        style: TextStyle(
          fontFamily: "AmaticSC",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
          .currentBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Filmster',
          style: TextStyle(fontFamily: "AmaticSC",
          fontSize: 34),
        ),
      ),
      drawer: DrawerMenu().build(context),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTitle("Change your Theme"),
                      SizedBox(
                        height: 40,
                      ),
                      _buildThemeButton(MyThemeKeys.LIGHT, "Light"),
                      _buildThemeButton(MyThemeKeys.DARK, "Dark"),
                      _buildThemeButton(MyThemeKeys.DARKER, "Darker"),
                    ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                     _buildTitle("Change you Language",),
                      SizedBox(height: 40,),
                      _buildLanguageButton("us", "English"),
                      _buildLanguageButton("ru", "Russian"),
                      _buildLanguageButton("pt", "Spanish"),
                    ],
                  ),
                ]),
                AdmobBanner(
                  adUnitId: addMobClass().getBannerAdUnitId(),
                  adSize: AdmobBannerSize.FULL_BANNER,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    addMobClass()
                        .handleEvent(event, args, 'Banner', scaffoldState);
                  },
                  onBannerCreated: (AdmobBannerController controller) {},
                ),
              ]),
        ),
      ),
    );
  }
}
