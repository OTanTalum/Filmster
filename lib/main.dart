//Widgets

import 'dart:io';

import 'package:filmster/providers/searchProvider.dart';
import 'package:filmster/providers/settingsProvider.dart';
import 'package:filmster/providers/themeProvider.dart';
import 'package:filmster/setting/adMob.dart';
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
      await Provider.of<SettingsProvider>(context, listen: false)
          .getGanresSettings();
    });
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
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Change your Theme",
                      style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: 26,
                        color:
                        Provider.of<ThemeProvider>(context, listen: false)
                            .currentFontColor,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .changeTheme(context, MyThemeKeys.LIGHT);
                      },
                      child: Text(
                        "Light!",
                        style: TextStyle(
                          fontFamily: "AmaticSC",
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .changeTheme(context, MyThemeKeys.DARK);
                      },
                      child: Text(
                        "Dark!",
                        style: TextStyle(
                          fontFamily: "AmaticSC",
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .changeTheme(context, MyThemeKeys.DARKER);
                      },
                      child: Text(
                        "Darker!",
                        style: TextStyle(
                          fontFamily: "AmaticSC",
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Change you Language",
                      style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: 26,
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .currentFontColor,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .changeLanguage("US");
                        await Provider.of<SettingsProvider>(context,
                                listen: false)
                            .getGanresSettings();
                      },
                      child: Text(
                        "English",
                        style: TextStyle(
                          fontFamily: "AmaticSC",
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .changeLanguage("ru");
                        await Provider.of<SettingsProvider>(context,
                                listen: false)
                            .getGanresSettings();
                      },
                      child: Text(
                        "Russian",
                        style: TextStyle(
                          fontFamily: "AmaticSC",
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .changeLanguage("pt");
                        await Provider.of<SettingsProvider>(context,
                                listen: false)
                            .getGanresSettings();
                      },
                      child: Text(
                        "Spanish",
                        style: TextStyle(
                          fontFamily: "AmaticSC",
                        ),
                      ),
                    ),
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
    );
  }
}
