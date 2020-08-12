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
import 'package:google_fonts/google_fonts.dart';
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
      await Provider.of<SettingsProvider>(context, listen:false).getGanresSettings();
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
      backgroundColor: Provider.of<ThemeProvider>(context,listen: false).currentBackgroundColor,
      appBar: AppBar(
        title: Text('Welcome',
          style: TextStyle(
              fontFamily:"AmaticSC"
          ),
        ),
      ),
      drawer: DrawerMenu().build(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40,),
            RaisedButton(
              onPressed: (){
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.LIGHT);
              },
              child: Text("Light!",
                style: TextStyle(fontFamily:"AmaticSC",),),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.DARK);
              },
              child: Text("Dark!",
                style: TextStyle(fontFamily:"AmaticSC",),),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.DARKER);
              },
              child: Text("Darker!",
              style: TextStyle(fontFamily:"AmaticSC",),),
            ),
            Divider(height: 100,),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: Provider.of<ThemeProvider>(context,listen: false).currentMainColor,
              width: 100,
              height: 100,
            ),
        ],
        ),
      AdmobBanner(
            adUnitId: addMobClass().getBannerAdUnitId(),
            adSize: AdmobBannerSize.FULL_BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              addMobClass().handleEvent(event, args, 'Banner', scaffoldState);
            },
            onBannerCreated: (AdmobBannerController controller) {},
          ),
      ]
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
