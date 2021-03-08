//@dart = 2.9
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:filmster/page/HomePage/HomePage.dart';
import 'package:filmster/providers/discoverProvider.dart';
import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/providers/trendingProvider.dart';
import 'package:filmster/providers/userProvider.dart';
import 'package:filmster/setting/sharedPreferenced.dart';
import 'package:filmster/setting/theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'Widgets/Pages/LogoScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TrendingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),
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

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final Trace mainTraceInit = FirebasePerformance.instance.newTrace("mainTraceInit");
  TabController _tabController;
  List<Widget> movieTrend = [];
  int currentPage = 1;
  bool isDone = false;
  SettingsProvider _settingsProvider;


  @override
  void initState() {
    _tabController =  new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  init() async {
    setState(() {
      mainTraceInit.start();
    });
      await initUser();
      await initLanguage();
      await initTheme();
      await _settingsProvider.loadMovieListGenres(scaffoldState);
      await _settingsProvider.loadTVListGenres(scaffoldState);
    setState(() {
      isDone = true;
      mainTraceInit.stop();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future initUser()async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (await Prefs().hasString("username")) {
      await userProvider.auth(
          await Prefs().getStringPrefs("username"),
          await Prefs().getStringPrefs("password"),
        scaffoldState
      );
      await userProvider.getFavoriteTv(scaffoldState);
      await userProvider.getFavoriteMovies(scaffoldState);
      await userProvider.getMarkedTVList(scaffoldState);
      await userProvider.getMarkedMovieList(scaffoldState);
      await userProvider.getChristian(scaffoldState);
      await userProvider.getLists(scaffoldState);
    }
    Provider.of<TrendingProvider>(context,listen: false).currentPage=1;
  }

  Future initLanguage() async {
    if (await Prefs().hasString("languageCode"))
      SettingsProvider.language =
          (await Prefs().getStringPrefs("languageCode"));
    else
      SettingsProvider.language = ("us");
    mainTraceInit.putAttribute("language", SettingsProvider.language.toString());
  }

  Future initTheme() async {
    var _provider = Provider.of<ThemeProvider>(context, listen: false);
    if (await Prefs().hasString("themeCode")) {
      String themeCode = await Prefs().getStringPrefs("themeCode");
      switch (themeCode) {
        case "Light":
          _provider.changeTheme(context, MyThemeKeys.LIGHT);
          break;
        case "Dark":
          _provider.changeTheme(context, MyThemeKeys.DARK);
          break;
        case "Darker":
          _provider.changeTheme(context, MyThemeKeys.DARKER);
          break;
        case "Loft":
          _provider.changeTheme(context, MyThemeKeys.Loft);
          break;
      }
    } else {
      _provider.changeTheme(context, MyThemeKeys.DARK);
    }
    mainTraceInit.putAttribute("theme", _provider.currentTheme.toString());
  }

  ///TODO 3. Attribution
  ///You shall use the TMDb logo to identify your use of the TMDb APIs.
  ///You shall place the following notice prominently on your application: "This product uses the TMDb API but is not endorsed or certified by TMDb."
  ///Any use of the TMDb logo in your application shall be less prominent than the logo or mark that primarily describes the application and your use of the TMDb logo shall not imply any endorsement by TMDb.

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
        key: scaffoldState,
        backgroundColor: Provider.of<ThemeProvider>(context, listen: false).currentBackgroundColor,
     body: !isDone
      ? LogoScreen()
      : HomePage(),
        //drawer: DrawerMenu().build(context),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}