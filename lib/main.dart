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
  Admob.initialize(addMobClass().getAdMobId());
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


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            AdmobBanner(
              adUnitId: addMobClass().getBannerAdUnitId(),
              adSize: addMobClass().bannerSize,
              listener: (AdmobAdEvent event,
                  Map<String, dynamic> args) {
                addMobClass().handleEvent(event, args, 'Banner', scaffoldState);
              },
              onBannerCreated:
                  (AdmobBannerController controller) {
                // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                // Normally you don't need to worry about disposing this yourself, it's handled.
                // If you need direct access to dispose, this is your guy!
                // controller.dispose();
              },
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
