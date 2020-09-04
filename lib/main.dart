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
      await initLanguage();
      await initTheme();
      await Provider.of<SettingsProvider>(context, listen: false)    // Load List of genres with current language//
          .getGanresSettings();
    });
  }

 Future initLanguage() async {
    if(await Prefs().hasString("languageCode"))
      SettingsProvider.language=(await Prefs().getStringPrefs("languageCode"));
    else SettingsProvider.language=("us");
  }

  Future initTheme() async {
    if(await Prefs().hasString("themeCode")) {
      String themeCode = await Prefs().getStringPrefs("themeCode");
      switch (themeCode) {
        case "Light":
          Provider.of<ThemeProvider>(context, listen: false)
              .changeTheme(context, MyThemeKeys.LIGHT);
          break;
        case "Dark":
          Provider.of<ThemeProvider>(context, listen: false)
              .changeTheme(context, MyThemeKeys.DARK);
          break;
        case "Darker":
          Provider.of<ThemeProvider>(context, listen: false)
              .changeTheme(context, MyThemeKeys.DARKER);
          break;
          case "Manyutka":
          Provider.of<ThemeProvider>(context, listen: false)
              .changeTheme(context, MyThemeKeys.Manyutka);
          break;
      }
    }
    else  Provider.of<ThemeProvider>(context, listen: false)
        .changeTheme(context, MyThemeKeys.DARK);
  }

  ///TODO 3. Attribution
  ///You shall use the TMDb logo to identify your use of the TMDb APIs.
  ///You shall place the following notice prominently on your application: "This product uses the TMDb API but is not endorsed or certified by TMDb."
  ///Any use of the TMDb logo in your application shall be less prominent than the logo or mark that primarily describes the application and your use of the TMDb logo shall not imply any endorsement by TMDb.

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
                Container(),
                AdmobBanner(
                  adUnitId: addMobClass().getBannerAdUnitId(),
                  adSize: AdmobBannerSize.FULL_BANNER,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                   ///todo something
                  },
                  onBannerCreated: (AdmobBannerController controller) {},
                ),
              ]),
        ),
      ),
    );
  }
}
