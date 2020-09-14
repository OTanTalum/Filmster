//Widgets

import 'dart:io';

import 'package:filmster/model/search.dart';
import 'package:filmster/page/films.dart';
import 'package:filmster/page/library.dart';
import 'package:filmster/page/settings_page.dart';
import 'package:filmster/page/trendingPage.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/trendingProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/adMob.dart';
import 'package:filmster/setting/api.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';
import 'package:filmster/widgets/CustomeBottomNavigationBar.dart';
import 'package:filmster/widgets/drawer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

//Flutter
import 'package:flutter/material.dart';
//Pages

import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TrendingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  List<Widget> movieTrend = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await initUser();
      await initLanguage();
      await initTheme();
      await Provider.of<SettingsProvider>(context, listen: false)
          .getGanresSettings("movie");
      await Provider.of<SettingsProvider>(context, listen: false)
          .getGanresSettings("tv");
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future initUser()async {
    print(await Prefs().hasString("username"));
    if (await Prefs().hasString("username")) {
    String username =  await Prefs().getStringPrefs("username");
    String password =   await Prefs().getStringPrefs("password");
    await Provider.of<UserProvider>(context, listen: false).auth(username,password);
    await Provider.of<UserProvider>(context, listen: false).getFavorite();
    await Provider.of<UserProvider>(context, listen: false).getWatchList();
    }
  }

  Future initLanguage() async {
    if (await Prefs().hasString("languageCode"))
      SettingsProvider.language =
          (await Prefs().getStringPrefs("languageCode"));
    else
      SettingsProvider.language = ("us");
  }

  Future initTheme() async {
    if (await Prefs().hasString("themeCode")) {
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
        case "Loft":
          Provider.of<ThemeProvider>(context, listen: false)
              .changeTheme(context, MyThemeKeys.Loft);
          break;
      }
    } else
      Provider.of<ThemeProvider>(context, listen: false)
          .changeTheme(context, MyThemeKeys.DARK);
  }

  ///TODO 3. Attribution
  ///You shall use the TMDb logo to identify your use of the TMDb APIs.
  ///You shall place the following notice prominently on your application: "This product uses the TMDb API but is not endorsed or certified by TMDb."
  ///Any use of the TMDb logo in your application shall be less prominent than the logo or mark that primarily describes the application and your use of the TMDb logo shall not imply any endorsement by TMDb.

  @override
  Widget build(BuildContext context) {
    var myColors = Provider.of<ThemeProvider>(context, listen: false);
    var mySettings = Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
        key: scaffoldState,
        backgroundColor: myColors.currentBackgroundColor,
        appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filmster',
                  style: TextStyle(fontFamily: "AmaticSC", fontSize: 34),
                ),
              ]),
        ),
        bottomNavigationBar: CustomeBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            mySettings.changePage(4);
            if(Provider.of<UserProvider>(context, listen: false).currentUser!=null){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LibraryPage()));
            }
          },
          elevation: 12,
          backgroundColor: myColors.currentSecondaryColor,
          child: Icon(
              Icons.favorite,
              color: mySettings.currentPage==4
                  ? myColors.currentMainColor
                  : myColors.currentFontColor
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //drawer: DrawerMenu().build(context),
        body: Stack(children: [
          TrendingPage(),
        ]));
  }
}
