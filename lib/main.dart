//Widgets


import 'dart:io';

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
      title: 'Flutter Demo',
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      backgroundColor: Provider.of<ThemeProvider>(context,listen: false).currentBackgroundColor,
      appBar: AppBar(
        title: Text('Welcome'),
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
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.LIGHT);
              },
              child: Text("Light!"),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.DARK);
              },
              child: Text("Dark!"),
            ),
            RaisedButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).changeTheme(context, MyThemeKeys.DARKER);
              },
              child: Text("Darker!"),
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AdmobBanner(
            adUnitId: addMobClass().getBannerAdUnitId(),
            adSize: AdmobBannerSize.FULL_BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              addMobClass().handleEvent(event, args, 'Banner', scaffoldState);
            },
            onBannerCreated: (AdmobBannerController controller) {},
          ),
        )
      ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Provider.of<ThemeProvider>(context,listen: false).currentBackgroundColor,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add,
        color: Provider.of<ThemeProvider>(context,listen: false).currentMainColor,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
